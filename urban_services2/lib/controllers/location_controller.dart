import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class GeoLocationController extends GetxController {
  Rx<LatLng> currentPosition = LatLng(0, 0).obs;

  Future<LatLng> fetchCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      currentPosition.value = LatLng(position.latitude, position.longitude);
      return currentPosition.value;
    } catch (error) {
      log('Error fetching location: $error');
      return LatLng(0, 0);
    }
  }
}
