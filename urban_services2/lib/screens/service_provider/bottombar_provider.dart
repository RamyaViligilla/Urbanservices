import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:urban_services/controllers/signin_controller.dart';
import 'package:urban_services/screens/service_provider/profile_provider.dart';

import 'MyServices.dart';
import 'home_provider.dart';



class BottombarProvider extends StatefulWidget {
  @override
  _BottombarProviderState createState() => _BottombarProviderState();
}

class _BottombarProviderState extends State<BottombarProvider> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    HomePageProvider(),
    ServicePackageListScreen(),
    ProfileScreenProvider()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool _loading = false;
  getData()async{
    setState(() {
      _loading = true;
    });
    if(!FirebaseAuth.instance.currentUser!.emailVerified){
      await controller.signOutUser();
    }
    setState(() {
      _loading = false;
    });
  }
  final controller =  Get.put(SigningController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Urban Service Provider'),
      ),
      body:  _loading ?  Center(child: CircularProgressIndicator(),) :    _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
 BottomNavigationBarItem(
            icon: Icon(Icons.cleaning_services),
            label: 'My Service',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}





