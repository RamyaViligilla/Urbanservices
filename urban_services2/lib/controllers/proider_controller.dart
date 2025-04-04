import 'dart:developer';
import 'dart:typed_data';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../model/provider_model.dart';

class ProviderController extends GetxController {
  Rx<ServiceProviderModel> loggedInUser = ServiceProviderModel().obs;
  Rx<bool> isLoading = false.obs;
  Future<bool> sendProviderToCloud(ServiceProviderModel userModel) async {
    try {
      userModel.password = encryptPassword(userModel.password ?? "");
      await FirebaseFirestore.instance
 .collection("Provider")
          .doc(userModel.uid)
          .set(userModel.toJson());
      return true;

    } catch (e) {
      return false;
    }
  }

  Future<void> gettingLoggedInUser()async{
    isLoading.value = true;
    var res = await FirebaseFirestore.instance

        .collection("Provider").doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    if(res.data()!=null) {
      loggedInUser.value = ServiceProviderModel.fromJson(res.data()!);
      isLoading.value = false;
    }
  }
  Future<String> uploadFileToCloud(Uint8List fileData) async {
    final FirebaseStorage cloudStorage = FirebaseStorage.instance;
    String uniqueId = Uuid().v1();
    Reference storageRef = cloudStorage.ref().child(uniqueId);
    SettableMetadata fileMetadata = SettableMetadata(contentType: 'image/jpeg');
    UploadTask uploadOperation = storageRef.putData(fileData, fileMetadata);
    TaskSnapshot taskResult = await uploadOperation;
    String fileUrl = await taskResult.ref.getDownloadURL();
    log(fileUrl);
    return fileUrl;
  }

  String encryptPassword(String password) {
    // Convert the password to bytes
    var bytes = utf8.encode(password);

    // Hash the password using SHA-256
    var digest = sha256.convert(bytes);

    // Convert the hash to a hexadecimal string
    return digest.toString();
  }
}