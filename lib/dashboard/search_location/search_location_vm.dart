import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_integration/location_fields/chi_search_location_picker/chi_search_location_widget.dart';
import 'package:maps_integration/secrets.dart';
import 'package:maps_integration/utils.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class SearchLocationVM extends BaseViewModel {
  final TextEditingController searchController = TextEditingController();
  List<LatLng> coordinates = [];
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};
  Timer? timer;
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

  onClickSearchedItem(
      SearchLocation searchLocation, BuildContext context) async {
    searchController.text = searchLocation.name;
    FocusManager.instance.primaryFocus?.unfocus();
    searchLocations.clear();
    if (coordinates.length > 1) {
      coordinates.removeAt(1);
      polylines.clear();
    }
    coordinates.add(LatLng(searchLocation.lat, searchLocation.lng));
    await onMapCreated(googleMapController!, context);
  }

  onMapCreated(GoogleMapController controller, context) async {
    googleMapController ??= controller;
    controller.animateCamera(
      polylines.isNotEmpty
          ? CameraUpdate.newLatLngBounds(
              LatLngBounds(
                  southwest: LatLng(
                      coordinates.first.latitude <= coordinates.last.latitude
                          ? coordinates.first.latitude
                          : coordinates.last.latitude,
                      coordinates.first.longitude <= coordinates.last.longitude
                          ? coordinates.first.longitude
                          : coordinates.last.longitude),
                  northeast: LatLng(
                      coordinates.first.latitude <= coordinates.last.latitude
                          ? coordinates.last.latitude
                          : coordinates.first.latitude,
                      coordinates.first.longitude <= coordinates.last.longitude
                          ? coordinates.last.longitude
                          : coordinates.first.longitude)),
              60)
          : CameraUpdate.newCameraPosition(
              CameraPosition(
                target: coordinates.last,
                zoom: 16.0,
              ),
            ),
    );
    markers.add(Marker(
        markerId: const MarkerId('MArker1'), position: coordinates.last));
    notifyListeners();
  }

  onGetCurrentLocation(BuildContext context) async {
    setBusy(true);
    Position position = await Utils.getCurrentPosition(context);
    coordinates.add(LatLng(position.latitude, position.longitude));
    setBusy(false);
  }

  onMakePolyline(context) async {
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

      onMapCreated(googleMapController!, context);
    }
  }
}
