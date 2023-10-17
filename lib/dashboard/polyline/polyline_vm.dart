import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_integration/utils.dart';
import 'package:stacked/stacked.dart';

class PolylineVM extends BaseViewModel {
  LatLng latLng = const LatLng(33.6397947, 72.9977447);
  LatLng desiredLatlng = const LatLng(33.6844, 73.0479);
  GoogleMapController? mapController;
  Set<Polyline> polylines = {};
  String desiredAddress = '';
  String address = '';

  onMapCreated(GoogleMapController controller) async {
    mapController ??= controller;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 16.0)));
    desiredAddress = await Utils.getAddressFromCoordinates(desiredLatlng);
    polylines = {
      Polyline(
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        polylineId: const PolylineId('polyline_id'),
        color: Colors.blue,
        points: [latLng, desiredLatlng],
        width: 5,
      ),
    };
    notifyListeners();
  }

  onGetCurrentLocation(BuildContext context) async {
    Position position = await Utils.getCurrentPosition(context);
    latLng = LatLng(position.latitude, position.longitude);
    address = await Utils.getAddressFromCoordinates(latLng);
    onMapCreated(mapController!);
    notifyListeners();
  }
}
