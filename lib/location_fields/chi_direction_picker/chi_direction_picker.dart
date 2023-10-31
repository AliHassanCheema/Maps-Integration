import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_integration/location_fields/chi_location_picker/chi_location_picker.dart';
import 'package:maps_integration/location_fields/chi_location_picker/polyline.dart';
import 'package:maps_integration/utils.dart';

// ignore: must_be_immutable
class CHIDirectionPicker extends StatefulWidget {
  CHIDirectionPicker({required this.onGetDirectionPolyline, super.key});

  Function(DirectionPolyline directionPolyline) onGetDirectionPolyline;

  @override
  State<CHIDirectionPicker> createState() => _CHIDirectionPickerState();
}

class _CHIDirectionPickerState extends State<CHIDirectionPicker> {
  String originAddress = 'Select Origin';
  String destinationAddress = 'Select Destination';
  String distance = '';
  String duration = '';
  LatLng? originLatLng;
  LatLng? destinationLatLng;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Origin:'),
            CHILocationPicker(
                selectedLatLng: originLatLng,
                pickerTitle: originAddress,
                onGetLatLng: (latlng) async {
                  originLatLng = latlng;
                  distance = '';
                  duration = '';
                  originAddress = await Utils.getAddressFromCoordinates(latlng);
                  setState(() {});
                }),
            const SizedBox(height: 12),
            const Text('Destination:'),
            CHILocationPicker(
                selectedLatLng: destinationLatLng,
                pickerTitle: destinationAddress,
                onGetLatLng: (latlng) async {
                  destinationLatLng = latlng;
                  destinationAddress =
                      await Utils.getAddressFromCoordinates(latlng);
                  distance = '';
                  duration = '';
                  setState(() {});
                }),
            const SizedBox(height: 12),
            distance == '' && duration == ''
                ? SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed:
                            originLatLng != null && destinationLatLng != null
                                ? () {
                                    Utils.pushRoute(
                                        context,
                                        CHIPolylineWidget(
                                          polylineCoordinates: [
                                            originLatLng!,
                                            destinationLatLng!
                                          ],
                                        )).then((value) {
                                      distance = value.distance;
                                      duration = value.duration;
                                      widget.onGetDirectionPolyline(value);
                                      setState(() {});
                                    });
                                  }
                                : null,
                        child: Text('Get Directions   $distance')),
                  )
                : _getDirections(distance)
          ],
        ),
      ),
    );
  }

  Widget _getDirections(String distance) {
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
            _getDirectionRow('Total Distance : ', distance),
            _getDirectionRow('Time : ', duration),
          ],
        ),
      ),
    );
  }

  Widget _getDirectionRow(String heading, String value) {
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
}
