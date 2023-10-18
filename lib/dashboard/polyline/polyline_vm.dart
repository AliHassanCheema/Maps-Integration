import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_integration/utils.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class PolylineVM extends BaseViewModel {
  LatLng originLatlng = const LatLng(33.6397947, 72.9977447);
  LatLng destinationLatlng = const LatLng(33.6844, 73.0479);
  GoogleMapController? mapController;
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};
  String desiredAddress = '';
  String address = '';
  // List<LatLng> polylinePoints = [];
  List<LatLng> isbCooordinates = [
    const LatLng(33.6397947, 72.9977447),
    const LatLng(33.6500, 73.0100),
    const LatLng(33.6600, 73.0200),
    const LatLng(33.6700, 73.0300),
    const LatLng(33.6844, 73.0479)
  ];

  Future<void> fetchPolyline(context) async {
    String apiKey = 'AIzaSyDsef6naWlgUqZwYN1AB_lH611BDaSOxPY';
    String origin = '${originLatlng.latitude},${originLatlng.longitude}';
    String destination =
        '${destinationLatlng.latitude},${destinationLatlng.longitude}';
    String apiUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final resp = json.decode(response.body);
      if (resp['status'] == "REQUEST_DENIED") {
        Utils.showSnackBar(context, resp['error_message']);
      } else {
        final routes = resp['routes'][0]['overview_polyline']['points'];
      }
      notifyListeners();
    }
  }

  onAddMarkers() async {
    for (int i = 0; i < isbCooordinates.length; i++) {
      String address =
          await Utils.getAddressFromCoordinates(isbCooordinates[i]);
      markers.add(
        Marker(
            markerId: MarkerId('$i'),
            infoWindow: InfoWindow(
                title: 'Address',
                snippet: address,
                anchor: const Offset(0.5, 0.1)),
            icon: BitmapDescriptor.defaultMarker,
            position: isbCooordinates[i]),
      );
    }
    polylines = {
      Polyline(
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        polylineId: const PolylineId('polyline_id'),
        color: Colors.blue,
        points: isbCooordinates,
        width: 5,
      ),
    };
  }

  onMapCreated(GoogleMapController controller, context) async {
    mapController ??= controller;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: originLatlng,
          zoom: 16.0,
        ),
      ),
    );
    desiredAddress = await Utils.getAddressFromCoordinates(destinationLatlng);

    onAddMarkers();

    fetchPolyline(context);
    notifyListeners();
  }

  onGetCurrentLocation(context) async {
    Position position = await Utils.getCurrentPosition(context);
    originLatlng = LatLng(position.latitude, position.longitude);
    isbCooordinates.insert(0, originLatlng);
    address = await Utils.getAddressFromCoordinates(originLatlng);
    onMapCreated(mapController!, context);
    notifyListeners();
  }
}
