import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:urban_services/model/provider_model.dart';
import 'package:urban_services/screens/User/booking_detail.dart';

import '../../controllers/servies_controller.dart';
import 'deatil.dart';

class AllBookings extends StatefulWidget {


  @override
  State<AllBookings> createState() => _AllBookingsState();
}

class _AllBookingsState extends State<AllBookings> {

  final providerController = Get.put(ServiceController());
  bool _loading = false;
  getData()async{
    setState(() {
      _loading = true;
    });
    await providerController.getAllBookedServices();
    setState(() {
      _loading = false;
    });
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("All bookings"),
      ),
      body: _loading ?  Center(child: CircularProgressIndicator(),) :SizedBox(
        height: MediaQuery.of(context).size.height,

        child: ListView(
          children: List.generate(providerController.allBookings.length, (index) {
            return InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookingDetails(serviceProvider: providerController.allBookings[index], isCompleted: false,)),
                );
              },
              child: Card(
                child: ListTile(
                  title: Text(providerController.allBookings[index].name ?? ""),
            subtitle: Text(providerController.allBookings[index].date ?? ""),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
