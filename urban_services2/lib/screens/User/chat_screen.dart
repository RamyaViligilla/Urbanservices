import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import 'package:urban_services/model/provider_model.dart';
import 'package:urban_services/screens/googleMap.dart';
import '../../controllers/location_controller.dart';
import '../../model/booked_serivece_model_user.dart';

class ChatScreen extends StatefulWidget {
  final BookedServiceUser providerModel;

  ChatScreen({required this.providerModel});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('AllMessage')
          .doc(uid)
          .collection("chats")
          .add({
        'text': _messageController.text,
        'createdAt': Timestamp.now(),
        'user': uid,
        'provider': widget.providerModel.uid,
        "sender": uid
      });
      _messageController.clear();
    }
  }

  List<QueryDocumentSnapshot> _sortChatDocs(
      List<QueryDocumentSnapshot> chatDocs) {
    chatDocs.sort((a, b) {
      Timestamp aTimestamp = a['createdAt'];
      Timestamp bTimestamp = b['createdAt'];
      return bTimestamp.compareTo(aTimestamp);
    });
    return chatDocs;
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('MMM dd, yyyy – h:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.providerModel.profilePic ?? ""),
            ),
            SizedBox(width: 10),
            Text(widget.providerModel.name ?? 'Chat'),
          ],
        ),
        actions: [
          Text("Share Location"),
          IconButton(
            icon: Icon(Icons.location_on, color: Colors.red),
            onPressed: () async {
              final locationController = Get.put(GeoLocationController());
              LatLng latLng =
              await locationController.fetchCurrentLocation();
              _messageController.text =
              "*****lat=${latLng.latitude}lon=${latLng.longitude}";
              _sendMessage();
              Get.snackbar("Location Sent",
                  "Your location has been shared.",
                  backgroundColor: Colors.teal,
                  colorText: Colors.white);
            },
          ),
        ],
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection('AllMessage')
                  .doc(uid)
                  .collection("chats")
                  .where("user", isEqualTo: uid)
                  .where("provider", isEqualTo: widget.providerModel.uid)
                  .snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
                if (chatSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (chatSnapshot.hasData) {
                  var chatDocs = chatSnapshot.data!.docs;
                  chatDocs = _sortChatDocs(chatDocs);
                  if (chatDocs.isEmpty) {
                    return Center(
                        child: Text("No conversations yet. Start chatting!",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade600)));
                  }

                  return ListView.builder(
                    reverse: true,
                    itemCount: chatDocs.length,
                    itemBuilder: (ctx, index) {
                      final chatData = chatDocs[index];
                      final bool currentUser = chatData['sender'] == uid;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 16),
                        child: InkWell(
                          onTap: () async {
                            if (chatData['text']
                                .toString()
                                .startsWith("*") &&
                                !currentUser) {
                              Map<String, double> dataMap =
                                  extractLatLon(chatData['text']) ?? {};
                              Get.to(() => LocationMapScreen(
                                locationName:
                                widget.providerModel.name ?? "",
                                lat: dataMap['latitude'] ?? 0,
                                lng: dataMap['longitude'] ?? 0,
                              ));
                            }
                          },
                          child: Align(
                            alignment: currentUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.all(12),
                              margin:
                              const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                color: currentUser
                                    ? Colors.teal.shade50
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: currentUser
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    chatData['text']
                                        .toString()
                                        .startsWith("*")
                                        ? "Shared Location"
                                        : chatData['text'],
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    _formatTimestamp(
                                        chatData["createdAt"]),
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (chatSnapshot.hasError) {
                  return Center(
                      child: Text(
                          "Error loading chat. Please try again later.",
                          style: TextStyle(
                              fontSize: 16, color: Colors.red)));
                }

                return Center(child: Text("No conversations found."));
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade300,
                    offset: Offset(0, -1),
                    blurRadius: 4),
              ],
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.teal),
                  onPressed: _sendMessage,
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, double>? extractLatLon(String input) {
    final regex = RegExp(r'lat=(-?\d+(\.\d+)?)lon=(-?\d+(\.\d+)?)');
    final match = regex.firstMatch(input);

    if (match != null && match.groupCount >= 3) {
      final lat = double.tryParse(match.group(1)!);
      final lon = double.tryParse(match.group(3)!);

      if (lat != null && lon != null) {
        return {'latitude': lat, 'longitude': lon};
      }
    }

    return null; // Return null if extraction or parsing fails
  }
}
