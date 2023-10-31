import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_integration/location_fields/chi_location_picker/polyline.dart';
import 'package:maps_integration/secrets.dart';
import 'package:maps_integration/utils.dart';
import 'package:http/http.dart' as http;

class CHISearchLocationWidget extends StatefulWidget {
  const CHISearchLocationWidget({super.key});

  @override
  State<CHISearchLocationWidget> createState() =>
      _CHISearchLocationWidgetState();
}

class _CHISearchLocationWidgetState extends State<CHISearchLocationWidget> {
  @override
  void initState() {
    onGetCurrentLocation(context);
    super.initState();
  }

  final TextEditingController searchController = TextEditingController();
  List<LatLng> coordinates = [];
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};
  Timer? timer;
  String? duration;
  String? distance;
  GoogleMapController? googleMapController;
  List<SearchLocation> searchLocations = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search Location'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(
                      context,
                      DirectionPolyline(
                          coordinates, distance ?? '--', duration ?? '--'));
                },
                icon: const Icon(Icons.check)),
          ],
        ),
        body: coordinates.isEmpty
            ? const LinearProgressIndicator()
            : Stack(
                children: [
                  _googleMapWidget(context),
                  Column(
                    children: [
                      _searchField(context),
                      coordinates.length < 2
                          ? const SizedBox.shrink()
                          : ElevatedButton(
                              onPressed: () {
                                onMakePolyline(context);
                              },
                              child: const Text('Get Directions')),
                      searchLocations.isEmpty
                          ? const SizedBox.shrink()
                          : searchList(),
                    ],
                  ),
                ],
              ),
        bottomSheet:
            distance != null && duration != null && polylines.isNotEmpty
                ? _pollyLineBottomSheet()
                : const SizedBox.shrink());
  }

  Widget _googleMapWidget(BuildContext context) {
    return GoogleMap(
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      onMapCreated: (controller) {
        onMapCreated(controller, context);
      },
      markers: markers,
      polylines: polylines,
      initialCameraPosition: CameraPosition(
        target: coordinates.last,
      ),
    );
  }

  Widget _bottomSheetRow(String heading, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          heading,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }

  Widget _searchField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 52,
        child: TextFormField(
          controller: searchController,
          textAlignVertical: TextAlignVertical.bottom,
          decoration: InputDecoration(
              suffixIcon: const Icon(Icons.search),
              fillColor: Colors.white,
              filled: true,
              enabledBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
              focusedBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
              hintText: 'Search for a place'),
          onChanged: (value) {
            if (timer != null) {
              timer?.cancel();
            }
            timer = Timer(const Duration(seconds: 1), () async {
              onSearch(value, context);
            });
          },
        ),
      ),
    );
  }

  Widget searchList() {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: searchLocations.length,
          itemBuilder: (context, index) {
            final result = searchLocations[index];
            return ListTile(
              onTap: () {
                onClickSearchedItem(result, context);
              },
              title: Text(result.name),
              subtitle: Text(result.address),
            );
          },
        ),
      ),
    );
  }

  Widget _pollyLineBottomSheet() {
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 127, 99, 175),
          borderRadius: BorderRadius.circular(12)),
      height: 100,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _bottomSheetRow('Total Distance : ', distance ?? '--'),
            _bottomSheetRow('Time : ', duration ?? '--'),
          ],
        ),
      ),
    );
  }

  Future<void> onSearch(String query, context) async {
    if (query.isEmpty) {
      searchLocations.clear();
      setState(() {});
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
        setState(() {});
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
    setState(() {});
  }

  onGetCurrentLocation(BuildContext context) async {
    Position position = await Utils.getCurrentPosition(context);
    coordinates.add(LatLng(position.latitude, position.longitude));
    setState(() {});
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

class SearchLocation {
  String name;
  String address;
  double lat;
  double lng;

  SearchLocation(this.name, this.address, this.lat, this.lng);
}
