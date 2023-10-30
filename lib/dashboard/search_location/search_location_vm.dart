import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_integration/secrets.dart';
import 'package:maps_integration/utils.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class SearchLocationVM extends BaseViewModel {
  final TextEditingController searchController = TextEditingController();
  List<LatLng> coordinates = [];
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};
  String? duration;
  String? distance;
  GoogleMapController? googleMapController;
  List<SearchLocation> searchLocations = [];
  Future<void> onSearch(String query, context) async {
    if (query.isEmpty) {
      searchLocations.clear();
      notifyListeners();
      return;
    }

    final response = await http.get(
        Uri.parse(
            'https://maps.googleapis.com/maps/api/place/textsearch/json?key=$googleMapsApiKey&query=$query'),
        headers: {'Accept': 'application/json'});
    if (response.statusCode == 200) {
      final resp = json.decode(response.body);
      if (resp['status'] == 'OK') {
        searchLocations.clear();
        resp['results'].map((e) {
          searchLocations.add(SearchLocation(
              e['name'],
              e['formatted_address'],
              e['geometry']['location']['lat'],
              e['geometry']['location']['lng']));
        }).toList();
        debugPrint('==========searchLocations========== $searchLocations');
        notifyListeners();
      } else {
        Utils.showSnackBar(context, resp['error_message']);
      }
    }
  }

  onClickSearchedItem(SearchLocation searchLocation, BuildContext context) {
    searchController.text = searchLocation.name;
    FocusManager.instance.primaryFocus?.unfocus();
    searchLocations.clear();
    coordinates.add(LatLng(searchLocation.lat, searchLocation.lng));
    onMapCreated(googleMapController!, context);
  }

  onMapCreated(GoogleMapController controller, context) async {
    googleMapController ??= controller;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: coordinates.last,
          zoom: 16.0,
        ),
      ),
    );
  }

  onGetCurrentLocation(BuildContext context) async {
    setBusy(true);
    Position position = await Utils.getCurrentPosition(context);
    coordinates.add(LatLng(position.latitude, position.longitude));
    setBusy(false);
  }

  onMakePolyline() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleMapsApiKey,
        PointLatLng(coordinates.first.latitude, coordinates.first.longitude),
        PointLatLng(coordinates.last.latitude, coordinates.last.longitude));
    if (result.points.isNotEmpty) {
      distance = result.distance;
      duration = result.duration;
      coordinates =
          result.points.map((e) => LatLng(e.latitude, e.longitude)).toList();
      polylines.add(Polyline(
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        polylineId: const PolylineId('polyline_id'),
        color: Colors.blue,
        points: coordinates,
        width: 5,
      ));
      notifyListeners();
    }
  }
}

class SearchLocation {
  String name;
  String address;
  double lat;
  double lng;

  SearchLocation(this.name, this.address, this.lat, this.lng);
}
