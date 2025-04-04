import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:urban_services/controllers/user_controller.dart';
import 'package:urban_services/model/booked_serivece_model_user.dart';
import 'package:urban_services/model/booked_service_model_provider.dart';
import 'package:urban_services/model/provider_model.dart';
import 'package:urban_services/model/review_model.dart';
import 'package:uuid/uuid.dart';

import '../model/service_package_model.dart';
import '../model/user_model.dart';

class ServiceController extends GetxController {
  RxList<ReviewModel> allRatings = <ReviewModel>[].obs;
  RxList<ServiceProviderModel> allProvider = <ServiceProviderModel>[].obs;
  RxList<BookedServiceUser> allBookings = <BookedServiceUser>[].obs;
  RxList<BookedServiceUser> allCompleted = <BookedServiceUser>[].obs;
  RxList<BookedServiceProvider> allBookingsProvider =
      <BookedServiceProvider>[].obs;
  RxList<BookedServiceProvider> allCompletedProvider =
      <BookedServiceProvider>[].obs;


  Future<bool> getAllProviders() async {
    try {
      allProvider.clear();
      String uid = FirebaseAuth.instance.currentUser!.uid;

      var res = await FirebaseFirestore.instance

          .collection("Provider")
          .get();
      for (var i in res.docs) {
        ServiceProviderModel model = ServiceProviderModel.fromJson(i.data());
        allProvider.add(model);
      }
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> bookService(BookedServiceUser userModel,
      BookedServiceProvider serviceProvider) async {
    try {
      String v1 = Uuid().v1();
      userModel.id = v1;
      serviceProvider.id = v1;
      userModel.status = "booked";
      serviceProvider.status = "booked";
      await FirebaseFirestore.instance

          .collection("Users")
          .doc(serviceProvider.uid)
          .collection("Booked Services")
          .doc(v1)
          .set(userModel.toJson());
      await FirebaseFirestore.instance

          .collection("Provider")
          .doc(userModel.uid)
          .collection("Booked Services")
          .doc(v1)
          .set(serviceProvider.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }
  Future<bool> sendRating(String uid, ReviewModel reviewModel) async {
    try {
      String uidCurrent = FirebaseAuth.instance.currentUser?.uid ?? "";
      String v1 = Uuid().v1();
      reviewModel.uid = uidCurrent;
      await FirebaseFirestore.instance

          .collection("Provider")
          .doc(uid)
          .collection("Review")
          .doc(v1)
          .set(reviewModel.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }
  Future<bool> getAllTheRatingsOfProvider(String uid) async {
    allRatings.clear();
    try {
      var  res = await FirebaseFirestore.instance

          .collection("Provider")
          .doc(uid)
          .collection("Review").get();
      for(var i in res.docs){
        ReviewModel model = ReviewModel.fromJson(i.data());
        allRatings.add(model);
      }
      return true;
    } catch (e) {
      return false;
    }
  }
double calculateRatin(){
    double stars = 0;
    for(var i in allRatings){
      stars+=(double.parse(i.rating ?? "0.0"));
    }
    double total = allRatings.length.toDouble();
    return stars/total;
}
  Future<bool> markCompleteService(BookedServiceProvider serviceProvider) async {
    try {
      await FirebaseFirestore.instance

          .collection("Users")
          .doc(serviceProvider.uid)
          .collection("Booked Services")
          .doc(serviceProvider.id)
          .update({"status": "completed"});
      await FirebaseFirestore.instance

          .collection("Provider")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("Booked Services")
          .doc(serviceProvider.id)
          .update({"status": "completed"});
      getAllBookedServicesProvider();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> getAllBookedServices() async {
    try {
      allBookings.clear();
      allCompleted.clear();
      var res = await FirebaseFirestore.instance

          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("Booked Services")
          .get();
      for (var i in res.docs) {
        BookedServiceUser model = BookedServiceUser.fromJson(i.data());
        if (model.status == "completed") {
          allCompleted.add(model);
        } else {
          allBookings.add(model);
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> getAllBookedServicesProvider() async {
    try {
      allBookingsProvider.clear();
      allCompletedProvider.clear();
      var res = await FirebaseFirestore.instance

          .collection("Provider")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("Booked Services")
          .get();
      for (var i in res.docs) {
        BookedServiceProvider model = BookedServiceProvider.fromJson(i.data());
        if (model.status == "completed") {
          allCompletedProvider.add(model);
        } else {
          allBookingsProvider.add(model);
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<String>> getServicePackages(String uid) async {
    try {
      List<String> ls = [];
      var res = await FirebaseFirestore.instance

          .collection("Provider")
          .doc(uid)
          .collection("Service Packages")
          .get();
      for (var i in res.docs) {
        ServicePackageModel servicePackageModel = ServicePackageModel.fromJson(i.data());
        ls.add("Name: ${servicePackageModel.pakcageName!} Service: ${servicePackageModel.serivices!}\n Price: ${servicePackageModel.price!}");
      }
      return ls;
    } catch (e) {
      return [];
    }
  }  Future<List<ServicePackageModel>> getServicePackagesModels(String uid) async {
    try {
      List<ServicePackageModel> ls = [];
      var res = await FirebaseFirestore.instance

          .collection("Provider")
          .doc(uid)
          .collection("Service Packages")
          .get();
      for (var i in res.docs) {
        ServicePackageModel servicePackageModel = ServicePackageModel.fromJson(i.data());
        ls.add(servicePackageModel);
      }
      return ls;
    } catch (e) {
      return [];
    }
  }
  Future<bool> uploadServicePackages(ServicePackageModel servicePackageModel) async {
    try {
      String v1 = Uuid().v1();
    servicePackageModel.id = v1;
      var res = await FirebaseFirestore.instance

          .collection("Provider")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("Service Packages").doc(v1).set(servicePackageModel.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<String>> getAllBookingOfCurrentProvider(String uid) async {
    List<String> allDates = [];
    try {
      var res = await FirebaseFirestore.instance
          .collection("Provider")
          .doc(uid)
          .collection("Booked Services")
          .get();
      for (var i in res.docs) {
        BookedServiceProvider model = BookedServiceProvider.fromJson(i.data());
        if (model.status == "completed") {

        } else {
         allDates.add(model.date ??"");
        }
      }
      return allDates;
    } catch (e) {
      return [];
    }
  }
}
