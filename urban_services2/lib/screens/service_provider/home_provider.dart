import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/servies_controller.dart';
import '../../model/booked_service_model_provider.dart';
import '../../model/user_model.dart';
import 'add_package.dart';
import 'booking_detail.dart';


class HomePageProvider extends StatefulWidget {
  @override
  State<HomePageProvider> createState() => _HomePageProviderState();
}

class _HomePageProviderState extends State<HomePageProvider> {
  final serviceController = Get.put(ServiceController());
  getData()async{
setState(() {
  _loading = true;

});
await serviceController.getAllBookedServicesProvider();

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

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Your Bookings",style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: _loading
            ? CircularProgressIndicator()
            : serviceController.allBookingsProvider.length ==0 ? Text("No Booking") :  Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
                children: List.generate(serviceController.allBookingsProvider.length, (index) {
                  BookedServiceProvider user = serviceController.allBookingsProvider[index];
                  return InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>BookingDetailsUser(serviceProvider: user,)));
                    },
                    child: ListTile(
                      title: Text(user.name ?? "") ,
                      subtitle: Text(user.email ?? ""),
                    ),
                  );
                })
            )
        ),
      ),
    );
  }
}

Widget _buildProfileDetail(String title, String? detail) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            detail ?? '',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    ),
  );
}