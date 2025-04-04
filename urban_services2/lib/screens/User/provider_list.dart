import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:urban_services/model/provider_model.dart';

import '../../controllers/servies_controller.dart';
import 'deatil.dart';
class ProviderList extends StatefulWidget {
  String category;
   ProviderList({super.key,required this.category});

  @override
  State<ProviderList> createState() => _ProviderListState();
}

class _ProviderListState extends State<ProviderList> {
  List<ServiceProviderModel> filterServiceProvidersByCategory(String category) {
    return providerController.allProvider.where((provider) => provider.serivceCategory == category).toList();
  }
  final providerController = Get.put(ServiceController());

  @override
  Widget build(BuildContext context) {
    List<ServiceProviderModel> allProviders = filterServiceProvidersByCategory(widget.category);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(widget.category),
      ),
      body: allProviders.isEmpty  ?  Center(child: Text("No Service Provider Found!"),)  : SizedBox(
        height: MediaQuery.of(context).size.height,

        child: ListView(
          children: List.generate(allProviders.length, (index) {
            return InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ServiceProviderDetailsScreen(serviceProvider: allProviders[index],)),
                );
              },
              child: Card(
                child: ListTile(
                  title: Text(allProviders[index].name ?? ""),
                  subtitle: Text(allProviders[index].email ?? ""),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
