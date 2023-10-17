import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_integration/utils.dart';
import 'package:stacked/stacked.dart';

class EditLocationVM extends BaseViewModel {
  LatLng latLng = const LatLng(33.6397947, 72.9977447);
  String address = '';
  Set<Marker> marker = {};
  // icon: BitmapDescriptor.fromBytes(await getBytesFromAsset(

  //         'asset/icons/ic_car_top_view.png', 70)),
  GoogleMapController? mapController;
  onMapCreated(GoogleMapController controller) async {
    mapController ??= controller;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 16.0)));
    marker = {
      Marker(
          markerId: const MarkerId('1'),
          infoWindow: InfoWindow(
              title: 'Address',
              snippet: await Utils.getAddressFromCoordinates(latLng),
              anchor: const Offset(0.5, 0.1)),
          icon: BitmapDescriptor.defaultMarker,
          position: latLng)
    };
    notifyListeners();
  }

  onSelectLocation(LatLng selectedLatLng) async {
    mapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: selectedLatLng, zoom: 16.0)));
    marker = {
      Marker(
          markerId: const MarkerId('1'),
          infoWindow: InfoWindow(
              title: 'Address',
              snippet: await Utils.getAddressFromCoordinates(selectedLatLng),
              anchor: const Offset(0.5, 0.1)),
          icon: BitmapDescriptor.defaultMarker,
          position: selectedLatLng)
    };
    notifyListeners();
  }

  onGetCurrentLocation(BuildContext context) async {
    Position position = await Utils.getCurrentPosition(context);
    latLng = LatLng(position.latitude, position.longitude);
    address = await Utils.getAddressFromCoordinates(latLng);
    onMapCreated(mapController!);
  }
}
