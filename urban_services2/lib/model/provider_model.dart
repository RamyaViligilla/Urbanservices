import 'dart:convert';

ServiceProviderModel serviceProviderModelFromJson(String str) => ServiceProviderModel.fromJson(json.decode(str));

String serviceProviderModelToJson(ServiceProviderModel data) => json.encode(data.toJson());

class ServiceProviderModel {
  String? name;
  String? email;
  String? phone;
  String? password;
  String? businessName;
  String? businessAddress;
  String? serivceCategory;
  String? serviceDescription;
  String? serviceArea;
  String? qualification;
  String? availibilitySchedule;
  String? profilePic;
  String? paymentInfo;
  String? uid;
  bool? verified; // New field added

  ServiceProviderModel({
    this.name,
    this.email,
    this.phone,
    this.password,
    this.businessName,
    this.businessAddress,
    this.serivceCategory,
    this.serviceDescription,
    this.serviceArea,
    this.qualification,
    this.availibilitySchedule,
    this.profilePic,
    this.paymentInfo,
    this.uid,
    this.verified, // Initialize the new field
  });

  factory ServiceProviderModel.fromJson(Map<String, dynamic> json) => ServiceProviderModel(
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    password: json["password"],
    businessName: json["business_name"],
    businessAddress: json["business_address"],
    serivceCategory: json["serivce_category"],
    serviceDescription: json["service_description"],
    serviceArea: json["service_area"],
    qualification: json["qualification"],
    availibilitySchedule: json["availibility_schedule"],
    profilePic: json["profilePic"],
    paymentInfo: json["payment_info"],
    uid: json["uid"],
    verified: json["verified"], // Map the new field
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "phone": phone,
    "password": password,
    "business_name": businessName,
    "business_address": businessAddress,
    "serivce_category": serivceCategory,
    "service_description": serviceDescription,
    "service_area": serviceArea,
    "qualification": qualification,
    "availibility_schedule": availibilitySchedule,
    "profilePic": profilePic,
    "payment_info": paymentInfo,
    "uid": uid,
    "verified": verified, // Add the new field to JSON
  };
}
