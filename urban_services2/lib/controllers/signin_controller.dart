import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:urban_services/controllers/proider_controller.dart';
import 'package:urban_services/controllers/user_controller.dart';
import 'package:urban_services/model/provider_model.dart';
import 'package:urban_services/model/user_model.dart';
import '../Services/token.dart';
import '../login_selection.dart';
import '../screens/verify_email_user.dart';

class SigningController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;

  final controllerUser = Get.put(UserController());
  final controllerProvider = Get.put(ProviderController());

  register(
      {required String email,
        required String password,
        required String userType,
        UserModel? user,
        ServiceProviderModel? provider,
        required BuildContext context}) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await TokenStorageMethods.storeTokenUserType(userType);
      String uid = credential.user?.uid ?? "";
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      Get.to(() => EmailVerificationScreen(
        user: user,
        provider: provider,
      ));

      return credential.user?.uid ?? "";
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred. Please try again.';

      if (e.code == 'email-already-in-use' || e.code == 'invalid-email') {
        message = 'The email address is invalid or already in use.';
      } else if (e.code == 'operation-not-allowed') {
        message = 'Registration is currently disabled.';
      }

      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return false;
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'An unexpected error occurred.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return false;
    }
  }

  Future<bool> login(
      {required String email,
        required String password,
        required String userType,
        required BuildContext context}) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      await TokenStorageMethods.storeTokenUserType(userType);
      print(credential.user!.uid ?? "");
      return true;
    } on FirebaseAuthException catch (e) {
      String message = 'Login failed. Please check your credentials.';

      if (e.code == 'too-many-requests' || e.code == 'user-disabled') {
        message = 'Account access temporarily restricted. Try again later.';
      }

      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return false;
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'An unknown error occurred.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return false;
    }
  }

  Future signOutUser() async {
    await _auth.signOut();
    TokenStorageMethods.removeAllTokens();
    Get.offAll(() => const LoginSelectionScreen());
    Fluttertoast.showToast(
      msg: 'You have been signed out.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
