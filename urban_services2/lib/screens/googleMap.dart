import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationMapScreen extends StatefulWidget {
  final String locationName;
  final double lat;  // Parameter for latitude
  final double lng; // Parameter for longitude

  LocationMapScreen({
    super.key,
    required this.locationName,
    required this.lat,
    required this.lng,
  });

  @override
  State<LocationMapScreen> createState() => _LocationMapScreenState();
}

class _LocationMapScreenState extends State<LocationMapScreen> {
  late LatLng coordinates;

  @override
  void initState() {
    super.initState();
    coordinates = LatLng(widget.lat, widget.lng);
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: screenHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: coordinates,
                    zoom: 12,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId('location_marker'),
                      position: coordinates,
                      infoWindow: InfoWindow(title: widget.locationName),
                    ),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
