import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'firebase_initializer.dart';
import 'Services/token.dart';
import 'package:urban_services/screens/admin/admin_home.dart';
import 'package:urban_services/screens/service_provider/bottombar_provider.dart';
import 'package:urban_services/screens/service_provider/home_provider.dart';
import 'screens/User/home_screen.dart';
import 'login_selection.dart';

bool provider = false;
bool admin = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await FirebaseInitializer.initializeFirebase();

  // Check user type from token storage
  String? value = await TokenStorageMethods.getTokenUserType();
  if (value != null) {
    if (value == "admin") {
      admin = true;
    }
    log(value);
    if (value == "provider") {
      provider = true;
    } else {
      provider = false;
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
        ),
        home: const HomeNavigation(), // Navigate based on user type
      ),
    );
  }
}

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({super.key});

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
    homeNavigation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Navigate to the appropriate screen based on user role
  homeNavigation() async {
    await Future.delayed(const Duration(seconds: 3));
    if (admin) {
      Get.off(() => AdminHome());
    } else if (provider) {
      Get.off(() => BottombarProvider());
    } else {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          Get.off(() => HomeScreen());
        } else {
          Get.off(() => LoginSelectionScreen());
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Container(
        height: 1.sh,
        width: 1.sw,
        child: Stack(
          children: [
            Center(
              child: FadeTransition(
                opacity: _animation,
                child: Text(
                  "Urban Services",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 50.h,
              left: 0,
              right: 0,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
