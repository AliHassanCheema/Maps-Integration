import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_integration/maps/maps_vm.dart';
import 'package:stacked/stacked.dart';

class MapsVU extends StackedView<MapsVM> {
  const MapsVU({super.key});

  @override
  Widget builder(BuildContext context, MapsVM viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Maps Integration',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true),
      body: viewModel.latLng == null
          ? const LinearProgressIndicator()
          : GoogleMap(
              zoomControlsEnabled: true,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              markers: {
                Marker(
                    markerId: const MarkerId('1'),
                    // infoWindow: const InfoWindow(
                    //     title: 'Google Map Test'),
                    icon: BitmapDescriptor.defaultMarker,
                    position: viewModel.latLng!)
              },
              initialCameraPosition: CameraPosition(
                  target: viewModel.latLng!,
                  tilt: 59.440717697143555,
                  zoom: 16),
            ),
    );
  }

  @override
  MapsVM viewModelBuilder(BuildContext context) {
    final vm = MapsVM();
    vm.onGetLocationPermissions();
    return vm;
  }
}
