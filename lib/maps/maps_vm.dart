import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

class MapsVM extends BaseViewModel {
  LatLng latLng = const LatLng(33.6397947, 72.9977447);

  onGetCurrentLocation(BuildContext context) async {
    setBusy(true);
    Position position = await getCurrentPosition(context);
    latLng = LatLng(position.latitude, position.longitude);
    setBusy(false);
  }

  /// Determine the current position of the device.
  /// When the location services are not enabled or permissions, it will return an error
  Future<Position> getCurrentPosition(context) async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showSnackBar(
          context, 'Please enable your location first and restart you app');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showSnackBar(context, 'You denied location permissions');
        getCurrentPosition(context);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showSnackBar(context,
          'Location permissions are permanently denied, we cannot request permissions.');
      await Geolocator.openLocationSettings();
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}

showSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(color: Colors.green))));
}
