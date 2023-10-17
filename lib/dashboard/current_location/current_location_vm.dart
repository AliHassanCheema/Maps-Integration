import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_integration/utils.dart';
import 'package:stacked/stacked.dart';

class CurrentLocationVM extends BaseViewModel {
  BitmapDescriptor pinIcon = BitmapDescriptor.defaultMarker;
  LatLng latLng = const LatLng(33.6397947, 72.9977447);
  GoogleMapController? mapController;
  String address = '';

  onMapCreated(GoogleMapController controller) async {
    mapController ??= controller;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 16.0)));
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(24, 24)),
            'assets/pinLocation.png')
        .then((onValue) {
      pinIcon = onValue;
    });
  }

  onGetCurrentLocation(BuildContext context) async {
    Position position = await Utils.getCurrentPosition(context);
    latLng = LatLng(position.latitude, position.longitude);
    address = await Utils.getAddressFromCoordinates(latLng);
    onMapCreated(mapController!);
    notifyListeners();
  }
}
