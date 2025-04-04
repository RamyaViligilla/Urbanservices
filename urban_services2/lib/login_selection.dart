import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:urban_services/screens/User/login.dart';
import 'package:urban_services/screens/admin/login.dart';
import 'package:urban_services/screens/service_provider/login.dart';
import 'package:urban_services/screens/widgets/flutterButton.dart';

class LoginSelectionScreen extends StatelessWidget {
  const LoginSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: 1.sh,
          width: 1.sw,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 50.h),
              _buildLoginOption(
                context,
                title: "Admin Login",
                onTap: () => Get.to(() => LoginScreenAdmin()),
              ),
              SizedBox(height: 30.h),
              _buildLoginOption(
                context,
                title: "Service Provider Login",
                onTap: () => Get.to(() => LoginScreenServiceProvider()),
              ),
              SizedBox(height: 30.h),
              _buildLoginOption(
                context,
                title: "User Login",
                onTap: () => Get.to(() => LoginScreen()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginOption(BuildContext context, {required String title, required VoidCallback onTap}) {
    return Card(
      elevation: 20,
      surfaceTintColor: Colors.blueAccent,
      color: Colors.blueAccent,
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: CustomizeUIButton(text: title),
          ),
        ],
      ),
    );
  }
}
