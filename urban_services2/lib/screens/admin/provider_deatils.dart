import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:urban_services/controllers/admin_controller.dart';

import '../../controllers/servies_controller.dart';
import '../../model/provider_model.dart';

class ServiceProviderDetailsScreenAdmin extends StatefulWidget {
  final ServiceProviderModel serviceProvider;

  ServiceProviderDetailsScreenAdmin({required this.serviceProvider});

  @override
  State<ServiceProviderDetailsScreenAdmin> createState() =>
      _ServiceProviderDetailsScreenAdminState();
}

class _ServiceProviderDetailsScreenAdminState
    extends State<ServiceProviderDetailsScreenAdmin> {
  double ratings = 0.0;
  bool _fetching = false;
  final serviceController = Get.put(ServiceController());
  bool _loading = false;
  getData() async {
    setState(() {
      _fetching = true;
    });
    await serviceController
        .getAllTheRatingsOfProvider(widget.serviceProvider.uid ?? "");
    setState(() {
      ratings = serviceController.calculateRatin();
      _fetching = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Service Provider Details'),
      ),
      body: _fetching
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        NetworkImage(widget.serviceProvider.profilePic ?? ''),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      Text(
                        ratings.toString().substring(0, 3),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.orange[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    widget.serviceProvider.name ?? '',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  widget.serviceProvider.verified ?? false
                      ? Center(
                          child: const Text(
                            "Verified",
                            style: TextStyle(color: Colors.green),
                          ),
                        )
                      : Center(
                          child: Text(
                            "Unverified",
                            style: TextStyle(color: Colors.red),
                          ),
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
                    leading: Icon(Icons.business),
                    title: Text(widget.serviceProvider.businessName ?? ''),
                    subtitle:
                        Text(widget.serviceProvider.businessAddress ?? ''),
                  ),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.tools),
                    title: Text(widget.serviceProvider.serivceCategory ?? ''),
                    subtitle:
                        Text(widget.serviceProvider.serviceDescription ?? ''),
                  ),
                  ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text(widget.serviceProvider.serviceArea ?? ''),
                  ),
                  ListTile(
                    leading: Icon(Icons.school),
                    title: Text(widget.serviceProvider.qualification ?? ''),
                  ),
                  ListTile(
                    leading: Icon(Icons.schedule),
                    title:
                        Text(widget.serviceProvider.availibilitySchedule ?? ''),
                  ),
                  ListTile(
                    leading: Icon(Icons.payment),
                    title: Text(widget.serviceProvider.paymentInfo ?? ''),
                  ),
                  _loading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : InkWell(
                          onTap: () async {
                            setState(() {
                              _loading = true;
                            });
                            final controller = Get.put(AdminController());
                            await controller
                                .verifyProvider(widget.serviceProvider, !widget.serviceProvider.verified!);
                            await serviceController.getAllProviders();
                            setState(() {
                              _loading = false;
                            });
                            Get.back();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blueAccent,
                            ),
                            height: 50,
                            width: 100,
                            child: Text(
                              widget.serviceProvider.verified ?? false
                                  ? "Unverified"
                                  : "Verify",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                ],
              ),
            ),
    );
  }
}
