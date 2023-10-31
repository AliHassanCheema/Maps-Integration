import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_integration/secrets.dart';

class CHIPolylineWidget extends StatefulWidget {
  CHIPolylineWidget({super.key, required this.polylineCoordinates});
  List<LatLng> polylineCoordinates;

  @override
  State<CHIPolylineWidget> createState() => _CHIPolylineWidgetState();
}

class _CHIPolylineWidgetState extends State<CHIPolylineWidget> {
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};
  String? distance;
  String? duration;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Directions'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(
                    context,
                    DirectionPolyline(widget.polylineCoordinates,
                        distance ?? '--', duration ?? '--'));
              },
              icon: const Icon(Icons.check)),
        ],
      ),
      body: _googleMapWidget(context),
      bottomSheet: distance != null && duration != null
          ? _pollyLineBottomSheet()
          : const SizedBox.shrink(),
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

  Row _bottomSheetRow(String heading, String value) {
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

  Widget _googleMapWidget(BuildContext context) {
    return GoogleMap(
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      onMapCreated: (controller) {
        onMapCreated(context, controller);
      },
      markers: markers,
      polylines: polylines,
      initialCameraPosition: CameraPosition(
        target: widget.polylineCoordinates.last,
        tilt: 59.440717697143555,
      ),
    );
  }

  onMapCreated(context, GoogleMapController controller) async {
    controller.animateCamera(
      polylines.isNotEmpty
          ? CameraUpdate.newLatLngBounds(
              LatLngBounds(
                  southwest: LatLng(
                      widget.polylineCoordinates.first.latitude <=
                              widget.polylineCoordinates.last.latitude
                          ? widget.polylineCoordinates.first.latitude
                          : widget.polylineCoordinates.last.latitude,
                      widget.polylineCoordinates.first.longitude <=
                              widget.polylineCoordinates.last.longitude
                          ? widget.polylineCoordinates.first.longitude
                          : widget.polylineCoordinates.last.longitude),
                  northeast: LatLng(
                      widget.polylineCoordinates.first.latitude <=
                              widget.polylineCoordinates.last.latitude
                          ? widget.polylineCoordinates.last.latitude
                          : widget.polylineCoordinates.first.latitude,
                      widget.polylineCoordinates.first.longitude <=
                              widget.polylineCoordinates.last.longitude
                          ? widget.polylineCoordinates.last.longitude
                          : widget.polylineCoordinates.first.longitude)),
              60)
          : CameraUpdate.newCameraPosition(
              CameraPosition(
                target: widget.polylineCoordinates.last,
                zoom: 16.0,
              ),
            ),
    );
    await onGetPolyLinePoints();
  }

  onGetPolyLinePoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleMapsApiKey,
        PointLatLng(widget.polylineCoordinates.first.latitude,
            widget.polylineCoordinates.first.longitude),
        PointLatLng(widget.polylineCoordinates.last.latitude,
            widget.polylineCoordinates.last.longitude));
    if (result.points.isNotEmpty) {
      distance = result.distance;
      duration = result.duration;
      widget.polylineCoordinates =
          result.points.map((e) => LatLng(e.latitude, e.longitude)).toList();
      debugPrint('${result.points}');
    }
    await onMakePolyline(
        result.startAddress ?? '--', result.endAddress ?? '--');
  }

  onMakePolyline(String originAddress, String destinationAddress) async {
    BitmapDescriptor carIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/car.png',
    );

    markers.add(
      Marker(
          markerId: const MarkerId('1'),
          infoWindow: InfoWindow(
              title: 'Address',
              snippet: originAddress,
              anchor: const Offset(0.5, 0.1)),
          icon: carIcon,
          position: widget.polylineCoordinates.first),
    );
    markers.add(
      Marker(
          markerId: const MarkerId('2'),
          infoWindow: InfoWindow(
              title: 'Address',
              snippet: destinationAddress,
              anchor: const Offset(0.5, 0.1)),
          icon: BitmapDescriptor.defaultMarker,
          position: widget.polylineCoordinates.last),
    );

    polylines = {
      Polyline(
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        polylineId: const PolylineId('polyline_id'),
        color: Colors.blue,
        points: widget.polylineCoordinates,
        width: 5,
      ),
    };
    setState(() {});
  }
}

class DirectionPolyline {
  List<LatLng> polylinePoints;
  String distance;
  String duration;

  DirectionPolyline(this.polylinePoints, this.distance, this.duration);
}
