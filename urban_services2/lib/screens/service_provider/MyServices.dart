import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:urban_services/controllers/servies_controller.dart';
import 'package:urban_services/model/service_package_model.dart';

import 'add_package.dart';

class ServicePackageListScreen extends StatefulWidget {


  @override
  State<ServicePackageListScreen> createState() => _ServicePackageListScreenState();
}

class _ServicePackageListScreenState extends State<ServicePackageListScreen> {
  final controller = Get.put(ServiceController());
  List<ServicePackageModel> packages = [];
  getPackages()async{
   List<ServicePackageModel> pac =  await controller.getServicePackagesModels(FirebaseAuth.instance.currentUser?.uid ?? "");
   setState(() {
     packages = pac;
   });
  }
  bool _loading = false;
  @override
  void initState() {
    setState(() {
      _loading= true;
    });
    // TODO: implement initState
    getPackages();
    setState(() {
      _loading= false;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        width: 200.w,
        child: FloatingActionButton(
          backgroundColor: Colors.orange,
          isExtended: true,
          child: Text(
            "Add Service Package ",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17.sp),
          ),
          onPressed: () {
            Get.to(()=>AddServicePackageForm());
          },
        ),
      ),
      body: _loading ?   Center(child: CircularProgressIndicator(),)    :  ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: packages.length,
        itemBuilder: (context, index) {
          return _buildPackageCard(packages[index]);
        },
      ),
    );
  }

  Widget _buildPackageCard(ServicePackageModel package) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              package.pakcageName ?? '',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.orange[800],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              package.serivices ?? '',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Price: \$${package.price ?? ''}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.orange[700],
              ),
            ),
            const SizedBox(height: 10),

          ],
        ),
      ),
    );
  }
}
