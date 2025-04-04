import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_services/model/user_model.dart';
import 'package:urban_services/screens/service_provider/login.dart';
import '../controllers/proider_controller.dart';
import '../controllers/user_controller.dart';
import '../model/provider_model.dart';
import 'User/login.dart';

class EmailVerificationScreen extends StatefulWidget {
  final UserModel? user;
  final ServiceProviderModel? provider;

  EmailVerificationScreen({Key? key, this.user, this.provider}) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  Timer? timer;

  final controllerUser = Get.put(UserController());
  final controllerProvider = Get.put(ProviderController());

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
    timer = Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  Future<void> checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email Successfully Verified")));
      if (widget.user != null) {
        widget.user?.uid = FirebaseAuth.instance.currentUser?.uid;
        await controllerUser.sendUserToCloud(widget.user!);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Congratulations! Your account has been created.')));
        Get.offAll(() => LoginScreen());
      } else {
        widget.provider?.uid = FirebaseAuth.instance.currentUser?.uid;
        widget.provider?.verified = false;

        await controllerProvider.sendProviderToCloud(widget.provider!);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Congratulations! Your account has been created.')));
        Get.offAll(() => LoginScreenServiceProvider());
      }

      timer?.cancel();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Icon(Icons.email_outlined, size: 100, color: Colors.blueAccent),
                SizedBox(height: 30),
                Text(
                  'Verify Your Email',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  'We have sent a verification link to your email:',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  '${FirebaseAuth.instance.currentUser?.email}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text(
                  'Verifying email...',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                ElevatedButton.icon(
                  icon: Icon(Icons.refresh, color: Colors.white),
                  label: Text('Resend Verification Email', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    try {
                      FirebaseAuth.instance.currentUser?.sendEmailVerification();
                    } catch (e) {
                      debugPrint('$e');
                    }
                  },
                ),
                SizedBox(height: 50),
                Text(
                  'Please check your inbox or spam folder for the verification email.',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
