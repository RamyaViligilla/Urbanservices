
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:urban_services/model/booked_serivece_model_user.dart';
import 'package:urban_services/screens/User/review_screen.dart';
import '../../controllers/servies_controller.dart';
import 'chat_screen.dart';


class BookingDetails extends StatefulWidget {
  final BookedServiceUser serviceProvider;
  bool isCompleted;

  BookingDetails({super.key, required this.serviceProvider,required this.isCompleted});

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  double ratings = 0.0;
  bool _fetching = false;
  final serviceController = Get.put(ServiceController());

  getData()async{
    setState(() {
      _fetching = true;
    });
    await serviceController.getAllTheRatingsOfProvider(widget.serviceProvider.uid ??"");
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
      body: _fetching ?  Center(child: CircularProgressIndicator(),)  : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(widget.serviceProvider.profilePic ?? ''),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star,color: Colors.amber,),
                Text(
                  ratings.toString().substring(0,3),
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.orange[700],
                  ),
                ),
              ],
            ),
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
              leading: Icon(Icons.business),
              title: Text(widget.serviceProvider.businessName ?? ''),
              subtitle: Text(widget.serviceProvider.businessAddress ?? ''),
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.tools),
              title: Text(widget.serviceProvider.serivceCategory ?? ''),
              subtitle: Text(widget.serviceProvider.serviceDescription ?? ''),
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
              title: Text(widget.serviceProvider.availibilitySchedule ?? ''),
            ),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text(widget.serviceProvider.paymentInfo ?? ''),
            ), ListTile(
              leading: Icon(Icons.monetization_on),
              title: Text(widget.serviceProvider.servicePackage ?? ''),
            ), ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text(widget.serviceProvider.date ?? ''),
            ),
          widget.isCompleted ? const SizedBox() :  InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreen(providerModel: widget.serviceProvider,)),
                );
              },
              child: const CircleAvatar(
                backgroundColor: Colors.blueAccent,
                radius: 25,
                child: Icon(Icons.chat_bubble,color: Colors.white,),
              ),
            ),
           !widget.isCompleted ?  SizedBox() :  ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  ReviewScreen(uid: widget.serviceProvider.uid ?? "",)),
                );
              },
              child: const Text('Give Review'),
            ),
          ],
        ),
      ),
    );
  }
}
