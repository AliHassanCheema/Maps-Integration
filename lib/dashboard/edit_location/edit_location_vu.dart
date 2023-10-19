import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_integration/dashboard/edit_location/edit_location_vm.dart';
import 'package:stacked/stacked.dart';

class EditLocationVU extends StackedView<EditLocationVM> {
  const EditLocationVU(
      {super.key,
      this.mapType = MapType.normal,
      this.liteModeEnabled = false,
      this.trafficEnabled = false,
      this.indoorViewEnabled = false});
  final MapType mapType;
  final bool liteModeEnabled;
  final bool trafficEnabled;
  final bool indoorViewEnabled;
  @override
  Widget builder(
      BuildContext context, EditLocationVM viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Location')),
      body: _googleMapWidget(viewModel),
      floatingActionButton: _currentLocationButton(viewModel, context),
    );
  }

  @override
  EditLocationVM viewModelBuilder(BuildContext context) {
    final vm = EditLocationVM();
    return vm;
  }

  Widget _currentLocationButton(
      EditLocationVM viewModel, BuildContext context) {
    return FloatingActionButton(
      heroTag: 'fab',
      shape: const StadiumBorder(),
      onPressed: () {
        viewModel.onGetCurrentLocation(context);
      },
      child: const Icon(Icons.location_searching_outlined),
    );
  }

  Widget _googleMapWidget(EditLocationVM viewModel) {
    return GoogleMap(
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      trafficEnabled: trafficEnabled,
      indoorViewEnabled: indoorViewEnabled,
      liteModeEnabled: liteModeEnabled,
      mapType: mapType,
      onMapCreated: (controller) {
        viewModel.onMapCreated(controller);
      },
      markers: viewModel.marker,
      onTap: (latlng) {
        viewModel.onSelectLocation(latlng);
      },
      onLongPress: (latlng) {
        viewModel.onSelectLocation(latlng);
      },
      initialCameraPosition: CameraPosition(
          target: viewModel.latLng, tilt: 59.440717697143555, zoom: 16),
    );
  }
}
