// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? name;
  String? email;
  String? phone;
  String? address;
  String? uid;
  String? contactMethod;
  String? profilePic;  // New variable for profile picture URL

  UserModel({
    this.name,
    this.email,
    this.phone,
    this.address,
    this.uid,
    this.contactMethod,
    this.profilePic,  // Initialize the profilePic variable
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    address: json["address"],
    uid: json["uid"],
    contactMethod: json["contact_method"],
    profilePic: json["profilePic"],  // Map the profilePic variable
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "phone": phone,
    "address": address,
    "uid": uid,
    "contact_method": contactMethod,
    "profilePic": profilePic,  // Convert profilePic to JSON
  };
}
