import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Utils {
  static showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg, style: const TextStyle(color: Colors.green))));
  }

  /// Determine the current position of the device.
  /// When the location services are not enabled or permissions, it will return an error
  static Future<Position> getCurrentPosition(context) async {
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

  static Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);

    if (placemarks.isEmpty) {
      return "No address found";
    }

    Placemark first = placemarks[0];
    String address =
        "${first.street}, ${first.subLocality}, ${first.locality}, ${first.country}";

    return address;
  }

  static pushRoute(BuildContext context, Widget route) {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return route;
    }));
  }
}
