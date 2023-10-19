import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_integration/utils.dart';
import 'package:stacked/stacked.dart';

class CurrentLocationVM extends BaseViewModel {
  BitmapDescriptor pinIcon = BitmapDescriptor.defaultMarker;
  LatLng? latLng;
  GoogleMapController? mapController;
  String address = '';

  onMapCreated(GoogleMapController controller) async {
    mapController ??= controller;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng!, zoom: 16.0)));
    notifyListeners();
  }

  onGetCurrentLocation(BuildContext context) async {
    Position position = await Utils.getCurrentPosition(context);
    latLng = LatLng(position.latitude, position.longitude);
    address = await Utils.getAddressFromCoordinates(latLng!);

    if (mapController != null) {
      onMapCreated(mapController!);
    } else {
      notifyListeners();
    }
  }
}
