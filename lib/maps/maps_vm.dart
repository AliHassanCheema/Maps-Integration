import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

class MapsVM extends BaseViewModel {
  LatLng? latLng;

  onGetLocationPermissions() async {
    setBusy(true);
    if (await Geolocator.isLocationServiceEnabled()) {
      LocationPermission locationPermission =
          await Geolocator.checkPermission();
      if (locationPermission.name == 'denied') {
        await Geolocator.requestPermission();
        Position position = await Geolocator.getCurrentPosition();
        latLng = LatLng(position.latitude, position.longitude);
      } else {
        Position position = await Geolocator.getCurrentPosition();
        latLng = LatLng(position.latitude, position.longitude);
      }
    } else {
      await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition();
      latLng = LatLng(position.latitude, position.longitude);
    }
    notifyListeners();
  }
}
