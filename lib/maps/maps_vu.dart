import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_integration/maps/maps_vm.dart';
import 'package:stacked/stacked.dart';

class MapsVU extends StackedView<MapsVM> {
  const MapsVU({super.key});

  @override
  Widget builder(BuildContext context, MapsVM viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: const Text('Maps Integration')),
      body: _googleMapWidget(viewModel),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab',
        shape: const StadiumBorder(),
        onPressed: () {
          viewModel.onGetCurrentLocation(context);
        },
        child: const Icon(Icons.location_searching_outlined),
      ),
    );
  }

  @override
  MapsVM viewModelBuilder(BuildContext context) {
    final vm = MapsVM();
    return vm;
  }

  Widget _googleMapWidget(MapsVM viewModel) {
    return GoogleMap(
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      onMapCreated: (controller) {
        viewModel.onMapCreated(controller);
      },
      markers: {
        Marker(
            markerId: const MarkerId('1'),
            infoWindow: InfoWindow(
                title: 'Address',
                snippet: viewModel.address,
                anchor: const Offset(0.5, 0.1)),
            icon: BitmapDescriptor.defaultMarker,
            position: viewModel.latLng)
      },
      initialCameraPosition: CameraPosition(
          target: viewModel.latLng, tilt: 59.440717697143555, zoom: 16),
    );
  }
}
