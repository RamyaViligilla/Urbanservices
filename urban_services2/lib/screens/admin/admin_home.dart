import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:urban_services/controllers/servies_controller.dart';
import 'package:urban_services/controllers/signin_controller.dart';
import 'package:urban_services/screens/admin/provider_deatils.dart';

import '../../model/provider_model.dart';
import '../User/deatil.dart';
class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  List<ServiceProviderModel> allProviders = [];
  final controller = Get.put(ServiceController());
  final cont = Get.put(SigningController());
  bool _loading = false;
  get()async{
    setState(() {
      _loading = true;
    });
    await controller.getAllProviders();
    setState(() {
      _loading = false;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    get();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Home"),
        actions: [
          IconButton(onPressed: ()async{
            await cont.signOutUser();
          }, icon: Icon(Icons.logout))
        ],
      ),
      body: _loading ? const Center(child: CircularProgressIndicator(),)  :   ListView(
        children:

        List.generate(controller.allProvider.length, (index) {
          return Obx(() {
            return ListTile(
                onTap: (){
                  Get.to(()=>ServiceProviderDetailsScreenAdmin(serviceProvider: controller.allProvider[index],));
                },
                title:Text(controller.allProvider[index].name ?? "" ),
                subtitle: Text(controller.allProvider[index].email ?? ""),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(controller.allProvider[index].profilePic ?? ""),
                ),
                trailing:controller.allProvider[index].verified??false ?  Text("Verified",style: TextStyle(
                    color: Colors.green
                ),)  :Text("Unverified",style: TextStyle(
                    color: Colors.red
                ),)
            );
          });
        }),
      ),
    );
  }
}
