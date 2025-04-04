import 'dart:convert';

// Function to parse JSON data into a BookedServiceUser object
BookedServiceUser serviceProviderModelFromJson(String str) => BookedServiceUser.fromJson(json.decode(str));

// Function to convert a BookedServiceUser object into a JSON string
String serviceProviderModelToJson(BookedServiceUser data) => json.encode(data.toJson());

class BookedServiceUser {
  String? id;
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
  String? servicePackage; // Field for service package
  String? date; // Field for date
  String? status; // New field for status

  BookedServiceUser({
  this.id,
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
    this.servicePackage, // Initialize new field
    this.date, // Initialize new field
    this.status, // Initialize new field
  });

  // Factory constructor to create a BookedServiceUser object from a JSON map
  factory BookedServiceUser.fromJson(Map<String, dynamic> json) => BookedServiceUser(
    name: json["name"],
    id: json["id"],
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
    servicePackage: json["service_package"], // Parse new field
    date: json["date"], // Parse new field
    status: json["status"], // Parse new field
  );

  // Method to convert a BookedServiceUser object into a JSON map
  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
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
    "service_package": servicePackage, // Serialize new field
    "date": date, // Serialize new field
    "status": status, // Serialize new field
  };
}
