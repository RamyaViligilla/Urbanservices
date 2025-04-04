import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Services/token.dart';
import '../model/provider_model.dart';

class AdminController extends GetxController {

  Future<bool> adminLoginFirebase({
    required String email,
    required String password,
    required String userType,
    required BuildContext context,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      var res = await FirebaseFirestore.instance
          .collection("Admin")
          .get();

      if (credential.user?.uid == res.docs[0].data()["uid"]) {
        await TokenStorageMethods.storeTokenUserType(userType);
        return true;
      } else {
        await FirebaseAuth.instance.signOut();
        Fluttertoast.showToast(
          msg: "Invalid login credentials. Please try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        return false;
      }
    } on FirebaseAuthException catch (e) {
      String message = "Login failed. Please check your details and try again.";

      if (e.code == 'too-many-requests' || e.code == 'user-disabled') {
        message = "Account access is temporarily restricted. Try again later.";
      }

      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return false;
    } catch (e) {
      Fluttertoast.showToast(
        msg: "An unexpected error occurred. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return false;
    }
  }

  Future<bool> verifyProvider(ServiceProviderModel userModel, bool val) async {
    try {
      await FirebaseFirestore.instance
          .collection("Provider")
          .doc(userModel.uid)
          .update({
        "verified": val
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
