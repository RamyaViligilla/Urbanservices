import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:urban_services/model/booked_service_model_provider.dart';
import '../../controllers/location_controller.dart';
import '../googleMap.dart';

class ChatScreenProvider extends StatefulWidget {
  final BookedServiceProvider userModel;

  ChatScreenProvider({required this.userModel});

  @override
  _ChatScreenProviderState createState() => _ChatScreenProviderState();
}

class _ChatScreenProviderState extends State<ChatScreenProvider> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String uid = FirebaseAuth.instance.currentUser?.uid ?? "";



  List<QueryDocumentSnapshot> _sortChatDocs(
      List<QueryDocumentSnapshot> chatDocs) {
    chatDocs.sort((a, b) {
      Timestamp aTimestamp = a['createdAt'];
      Timestamp bTimestamp = b['createdAt'];
      return bTimestamp.compareTo(aTimestamp); // Descending order
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
              if (_messageController.text.isNotEmpty) {
                await _firestore
                    .collection('AllMessage')
                    .doc(widget.userModel.uid)
                    .collection("chats")
                    .add({
                  'text': _messageController.text,
                  'createdAt': Timestamp.now(),
                  "user": widget.userModel.uid,
                  "provider": uid,
                  "sender": uid,
                });
                _messageController.clear();
              }
              Get.snackbar("Location Sent",
                  "Your location has been shared.",
                  backgroundColor: Colors.teal,
                  colorText: Colors.white);
            },
          ),
        ],
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.userModel.profilePic ?? ""),
            ),
            SizedBox(width: 10),
            Text(widget.userModel.name ?? 'Chat'),
          ],
        ),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection('AllMessage')
                  .doc(widget.userModel.uid)
                  .collection("chats")
                  .where("provider", isEqualTo: uid)
                  .where("user", isEqualTo: widget.userModel.uid)
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
                      final bool isMe = chatData['sender'] == uid;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 16),
                        child: InkWell(
                          onTap: () async {
                            log("message");
                            if (chatData['text']
                                .toString()
                                .startsWith("*") &&
                                !isMe) {
                              log("++mnb");
                              Map<String, double> mp =
                                  extractLatLon(chatData['text']) ?? {};
                              Get.to(() => LocationMapScreen(
                                locationName: widget.userModel.name ?? "",
                                lat: mp['latitude'] ?? 0,
                                lng: mp['longitude'] ?? 0,
                              ));
                            }
                          },
                          child: Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.all(12),
                              margin:
                              const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? Colors.teal.shade50
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: isMe
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
                    onSubmitted: (_) async{
                      if (_messageController.text.isNotEmpty) {
                        await _firestore
                            .collection('AllMessage')
                            .doc(widget.userModel.uid)
                            .collection("chats")
                            .add({
                          'text': _messageController.text,
                          'createdAt': Timestamp.now(),
                          "user": widget.userModel.uid,
                          "provider": uid,
                          "sender": uid,
                        });
                        _messageController.clear();
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.teal),
                  onPressed: ()async{
                    if (_messageController.text.isNotEmpty) {
                      await _firestore
                          .collection('AllMessage')
                          .doc(widget.userModel.uid)
                          .collection("chats")
                          .add({
                        'text': _messageController.text,
                        'createdAt': Timestamp.now(),
                        "user": widget.userModel.uid,
                        "provider": uid,
                        "sender": uid,
                      });
                      _messageController.clear();
                    }
                  },
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
