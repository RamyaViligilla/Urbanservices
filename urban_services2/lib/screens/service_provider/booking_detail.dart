import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:urban_services/controllers/servies_controller.dart';
import 'package:urban_services/model/booked_serivece_model_user.dart';
import 'package:urban_services/model/booked_service_model_provider.dart';
import 'package:urban_services/screens/User/review_screen.dart';

import 'chat_screen_provider.dart';

class BookingDetailsUser extends StatefulWidget {
  final BookedServiceProvider serviceProvider;

  BookingDetailsUser({required this.serviceProvider});

  @override
  State<BookingDetailsUser> createState() => _BookingDetailsUserState();
}

class _BookingDetailsUserState extends State<BookingDetailsUser> {
  bool _loading = false;
  final controller = Get.put(ServiceController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Booking Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.serviceProvider.profilePic ?? ""),
            ),
            SizedBox(height: 20),
            Text(
              widget.serviceProvider.name ?? '',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.email),
              title: Text(widget.serviceProvider.email ?? ''),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text(widget.serviceProvider.phone ?? ''),
            ),
            ListTile(
              leading: Icon(Icons.pin_drop),
              title: Text(widget.serviceProvider.address ?? ''),
            ),
            ListTile(
              leading: Icon(Icons.monetization_on),
              title: Text(widget.serviceProvider.servicePackage ?? ''),
            ),
            ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text(widget.serviceProvider.date ?? ''),
            ),
            InkWell(
              onTap: () {
                Get.to(() => ChatScreenProvider(
                      userModel: widget.serviceProvider,
                    ));
              },
              child: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                radius: 25,
                child: Icon(
                  Icons.chat_bubble,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            _loading
                ? Center(child: CircularProgressIndicator())
                : InkWell(
                    onTap: () async {
                      setState(() {
                        _loading = true;
                      });
                      await controller.markCompleteService(widget.serviceProvider);
                      Get.back();
                      setState(() {
                        _loading = false;
                      });
                    },
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blueAccent,
                      ),
                      child: Text(
                        "Bokking Complete",
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
          ],
        ),
      ),
    );
  }
}
