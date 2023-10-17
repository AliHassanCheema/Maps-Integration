import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_integration/dashboard/polyline/polyline_vm.dart';
import 'package:stacked/stacked.dart';

class PolylineVU extends StackedView<PolylineVM> {
  const PolylineVU({super.key});

  @override
  Widget builder(BuildContext context, PolylineVM viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: const Text('Polyline between locations')),
      body: _googleMapWidget(viewModel),
      floatingActionButton: currentLocationButton(viewModel, context),
    );
  }

  @override
  PolylineVM viewModelBuilder(BuildContext context) {
    final vm = PolylineVM();
    return vm;
  }

  Widget currentLocationButton(PolylineVM viewModel, BuildContext context) {
    return FloatingActionButton(
      heroTag: 'fab',
      shape: const StadiumBorder(),
      onPressed: () {
        viewModel.onGetCurrentLocation(context);
      },
      child: const Icon(Icons.location_searching_outlined),
    );
  }

  Widget _googleMapWidget(PolylineVM viewModel) {
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
            position: viewModel.latLng),
        Marker(
            markerId: const MarkerId('2'),
            infoWindow: InfoWindow(
                title: 'Address',
                snippet: viewModel.desiredAddress,
                anchor: const Offset(0.5, 0.1)),
            icon: BitmapDescriptor.defaultMarker,
            position: viewModel.desiredLatlng)
      },
      polylines: viewModel.polylines,
      initialCameraPosition: CameraPosition(
          target: viewModel.latLng, tilt: 59.440717697143555, zoom: 16),
    );
  }
}
