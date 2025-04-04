import 'dart:convert';

class ServicePackageModel {
  String? id;
  String? pakcageName;
  String? serivices;
  String? price;

  ServicePackageModel({
    this.id,
    this.pakcageName,
    this.serivices,
    this.price,
  });

  factory ServicePackageModel.fromJson(Map<String, dynamic> json) => ServicePackageModel(
    id: json["id"],
    pakcageName: json["pakcage_name"],
    serivices: json["serivices"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "pakcage_name": pakcageName,
    "serivices": serivices,
    "price": price,
  };
}
