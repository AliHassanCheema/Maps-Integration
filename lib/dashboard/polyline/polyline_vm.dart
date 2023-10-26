import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_integration/secrets.dart';
import 'package:maps_integration/utils.dart';
import 'package:stacked/stacked.dart';

class PolylineVM extends BaseViewModel {
  GoogleMapController? mapController;
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};

  List<LatLng> isbCooordinates = [
    const LatLng(33.6397947, 72.9977447),
    const LatLng(33.661546, 73.078217)
  ];

  onGetPolyLinePoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleMapsApiKey,
        PointLatLng(
            isbCooordinates.first.latitude, isbCooordinates.first.longitude),
        PointLatLng(
            isbCooordinates.last.latitude, isbCooordinates.last.longitude));
    if (result.points.isNotEmpty) {
      isbCooordinates =
          result.points.map((e) => LatLng(e.latitude, e.longitude)).toList();
      debugPrint('${result.points}');
    }
  }

  onMakePolyline() async {
    BitmapDescriptor carIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/car.png',
    );
    String originAddress =
        await Utils.getAddressFromCoordinates(isbCooordinates.first);
    String destinationAddress =
        await Utils.getAddressFromCoordinates(isbCooordinates.last);
    markers.add(
      Marker(
          markerId: const MarkerId('1'),
          infoWindow: InfoWindow(
              title: 'Address',
              snippet: originAddress,
              anchor: const Offset(0.5, 0.1)),
          icon: carIcon,
          position: isbCooordinates.first),
    );
    markers.add(
      Marker(
          markerId: const MarkerId('2'),
          infoWindow: InfoWindow(
              title: 'Address',
              snippet: destinationAddress,
              anchor: const Offset(0.5, 0.1)),
          icon: BitmapDescriptor.defaultMarker,
          position: isbCooordinates.last),
    );

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
    Position position = await Utils.getCurrentPosition(context);
    isbCooordinates.first = LatLng(position.latitude, position.longitude);
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: isbCooordinates.first,
          zoom: 16.0,
        ),
      ),
    );
    await onGetPolyLinePoints();
    await onMakePolyline();
    notifyListeners();
  }

  onGetCurrentLocation(context) async {
    Position position = await Utils.getCurrentPosition(context);
    isbCooordinates.first = LatLng(position.latitude, position.longitude);
    onMapCreated(mapController!, context);
  }
}
