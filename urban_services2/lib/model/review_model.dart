// To parse this JSON data, do
//
//     final reviewModel = reviewModelFromJson(jsonString);

import 'dart:convert';

ReviewModel reviewModelFromJson(String str) => ReviewModel.fromJson(json.decode(str));

String reviewModelToJson(ReviewModel data) => json.encode(data.toJson());

class ReviewModel {
  String? uid;
  String? rating;
  String? review;

  ReviewModel({
    this.uid,
    this.rating,
    this.review,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
    uid: json["uid"],
    rating: json["rating"],
    review: json["review"],
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "rating": rating,
    "review": review,
  };
}
