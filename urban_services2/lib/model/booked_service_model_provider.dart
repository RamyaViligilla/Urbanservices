import 'dart:convert';

// Function to parse JSON data into a BookedServiceProvider object
BookedServiceProvider userModelFromJson(String str) => BookedServiceProvider.fromJson(json.decode(str));

// Function to convert a BookedServiceProvider object into a JSON string
String userModelToJson(BookedServiceProvider data) => json.encode(data.toJson());

class BookedServiceProvider {
  String? id; // New field for ID
  String? name;
  String? email;
  String? phone;
  String? password;
  String? address;
  String? uid;
  String? contactMethod;
  String? servicePackage; // Field for service package
  String? date; // Field for date
  String? status; // Field for status
  String? profilePic; // New field for profile picture

  BookedServiceProvider({
    this.id, // Initialize ID field
    this.name,
    this.email,
    this.phone,
    this.password,
    this.address,
    this.uid,
    this.contactMethod,
    this.servicePackage, // Initialize service package field
    this.date, // Initialize date field
    this.status, // Initialize status field
    this.profilePic, // Initialize profile picture field
  });

  // Factory constructor to create a BookedServiceProvider object from a JSON map
  factory BookedServiceProvider.fromJson(Map<String, dynamic> json) => BookedServiceProvider(
    id: json["id"], // Parse ID field
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    password: json["password"],
    address: json["address"],
    uid: json["uid"],
    contactMethod: json["contact_method"],
    servicePackage: json["service_package"], // Parse service package field
    date: json["date"], // Parse date field
    status: json["status"], // Parse status field
    profilePic: json["profilePic"], // Parse profile picture field
  );

  // Method to convert a BookedServiceProvider object into a JSON map
  Map<String, dynamic> toJson() => {
    "id": id, // Serialize ID field
    "name": name,
    "email": email,
    "phone": phone,
    "password": password,
    "address": address,
    "uid": uid,
    "contact_method": contactMethod,
    "service_package": servicePackage, // Serialize service package field
    "date": date, // Serialize date field
    "status": status, // Serialize status field
    "profilePic": profilePic, // Serialize profile picture field
  };
}
