import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_integration/dashboard/polyline/polyline_vm.dart';
import 'package:stacked/stacked.dart';

class PolylineVU extends StackedView<PolylineVM> {
  const PolylineVU({super.key, this.mapType = MapType.normal});
  final MapType mapType;

  @override
  Widget builder(BuildContext context, PolylineVM viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: const Text('Polyline Location')),
      body: _googleMapWidget(viewModel, context),
      floatingActionButton: _currentLocationButton(viewModel, context),
    );
  }

  @override
  PolylineVM viewModelBuilder(BuildContext context) {
    final vm = PolylineVM();
    return vm;
  }

  Widget _currentLocationButton(PolylineVM viewModel, BuildContext context) {
    return FloatingActionButton(
      heroTag: 'fab',
      shape: const StadiumBorder(),
      onPressed: () {
        viewModel.onGetCurrentLocation(context);
      },
      child: const Icon(Icons.location_searching_outlined),
    );
  }

  Widget _googleMapWidget(PolylineVM viewModel, BuildContext context) {
    return GoogleMap(
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      mapType: mapType,
      onMapCreated: (controller) {
        viewModel.onMapCreated(controller, context);
      },
      markers: viewModel.markers,
      polylines: viewModel.polylines,
      initialCameraPosition: CameraPosition(
          target: viewModel.isbCooordinates.last,
          tilt: 59.440717697143555,
          zoom: 16),
    );
  }
}
