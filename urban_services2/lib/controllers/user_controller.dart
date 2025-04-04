import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../model/user_model.dart';

class UserController extends GetxController {
  Rx<UserModel> currentUser = UserModel().obs;
  Future<bool> sendUserToCloud(UserModel userModel) async {
    try {
      await FirebaseFirestore.instance
.collection("Users")
          .doc(userModel.uid)
          .set(userModel.toJson());
      return true;

    } catch (e) {
      return false;
    }
  }

Future<void> getCurrentLoggedInUser()async{
  var res = await FirebaseFirestore.instance

      .collection("Users").doc(FirebaseAuth.instance.currentUser?.uid)
      .get();
  if(res.data()!=null) {
    currentUser.value = UserModel.fromJson(res.data()!);
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

}