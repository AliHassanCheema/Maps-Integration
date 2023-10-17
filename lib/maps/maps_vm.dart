import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_integration/utils.dart';
import 'package:stacked/stacked.dart';

class MapsVM extends BaseViewModel {
  LatLng latLng = const LatLng(33.6397947, 72.9977447);
  String address = '';
  // icon: BitmapDescriptor.fromBytes(await getBytesFromAsset(

  //         'asset/icons/ic_car_top_view.png', 70)),
  Completer<GoogleMapController> mapController = Completer();
  onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);
  }

  onGetCurrentLocation(BuildContext context) async {
    Position position = await Utils.getCurrentPosition(context);
    latLng = LatLng(position.latitude, position.longitude);
    address = await Utils.getAddressFromCoordinates(
        position.latitude, position.longitude);
    notifyListeners();
  }
}
