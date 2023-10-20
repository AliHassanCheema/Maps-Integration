import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_integration/utils.dart';

class CHIGoogleMap extends StatefulWidget {
  CHIGoogleMap({super.key, this.selectedLatLng});
  LatLng? selectedLatLng;
  @override
  State<CHIGoogleMap> createState() => _CHIGoogleMapState();
}

class _CHIGoogleMapState extends State<CHIGoogleMap> {
  Set<Marker> marker = {};
  GoogleMapController? mapController;
  @override
  void initState() {
    if (widget.selectedLatLng == null) {
      _onGetCurrentLocation(context);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context, widget.selectedLatLng);
            },
          )
        ],
      ),
      body: widget.selectedLatLng == null
          ? const Center(child: CircularProgressIndicator())
          : _googleMapWidget(),
      floatingActionButton: _currentLocationButton(context),
    ));
  }

  Widget _currentLocationButton(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'fab',
      shape: const StadiumBorder(),
      onPressed: () {
        _onGetCurrentLocation(context);
      },
      child: const Icon(Icons.location_searching_outlined),
    );
  }

  Widget _googleMapWidget() {
    return GoogleMap(
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      mapType: MapType.normal,
      onMapCreated: (controller) {
        _onMapCreated(controller);
      },
      markers: marker,
      onTap: (latlng) {
        _onSelectLocation(latlng);
      },
      onLongPress: (latlng) {
        _onSelectLocation(latlng);
      },
      initialCameraPosition: CameraPosition(
          target: widget.selectedLatLng!, tilt: 59.440717697143555, zoom: 16),
    );
  }

  _onMapCreated(GoogleMapController controller) async {
    mapController ??= controller;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: widget.selectedLatLng!, zoom: 16.0)));
    marker = {
      Marker(
          markerId: const MarkerId('1'),
          infoWindow: InfoWindow(
              title: 'Address',
              snippet:
                  await Utils.getAddressFromCoordinates(widget.selectedLatLng!),
              anchor: const Offset(0.5, 0.1)),
          icon: BitmapDescriptor.defaultMarker,
          position: widget.selectedLatLng!)
    };
    setState(() {});
  }

  _onSelectLocation(LatLng selectedLatLng) async {
    widget.selectedLatLng = selectedLatLng;
    mapController?.animateCamera(CameraUpdate.newCameraPosition(
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
    setState(() {});
  }

  _onGetCurrentLocation(BuildContext context) async {
    Position position = await _getCurrentPosition(context);
    widget.selectedLatLng = LatLng(position.latitude, position.longitude);
    if (mapController != null) {
      _onMapCreated(mapController!);
    }
    setState(() {});
  }

  Future<Position> _getCurrentPosition(context) async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackBar(
          context, 'Please enable your location first and restart you app');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackBar(context, 'You denied location permissions');
        _getCurrentPosition(context);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnackBar(context,
          'Location permissions are permanently denied, we cannot request permissions.');
      await Geolocator.openLocationSettings();
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  _showSnackBar(BuildContext context, String msg, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.white38,
        content: Text(msg,
            style: TextStyle(color: isError ? Colors.red : Colors.green))));
  }
}
