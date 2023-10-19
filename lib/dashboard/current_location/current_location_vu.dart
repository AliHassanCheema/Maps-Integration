import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_integration/dashboard/current_location/current_location_vm.dart';
import 'package:stacked/stacked.dart';

class CurrentLocationVU extends StackedView<CurrentLocationVM> {
  const CurrentLocationVU(
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
      BuildContext context, CurrentLocationVM viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: const Text('Current Location')),
      body: viewModel.latLng == null
          ? const LinearProgressIndicator()
          : _googleMapWidget(viewModel),
      floatingActionButton: _currentLocationButton(viewModel, context),
    );
  }

  @override
  CurrentLocationVM viewModelBuilder(BuildContext context) {
    final vm = CurrentLocationVM();
    vm.onGetCurrentLocation(context);
    return vm;
  }

  Widget _currentLocationButton(
      CurrentLocationVM viewModel, BuildContext context) {
    return FloatingActionButton(
      heroTag: 'fab',
      shape: const StadiumBorder(),
      onPressed: () {
        viewModel.onGetCurrentLocation(context);
      },
      child: const Icon(Icons.location_searching_outlined),
    );
  }

  Widget _googleMapWidget(CurrentLocationVM viewModel) {
    return GoogleMap(
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      mapType: mapType,
      compassEnabled: true,
      trafficEnabled: trafficEnabled,
      indoorViewEnabled: indoorViewEnabled,
      liteModeEnabled: liteModeEnabled,
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
            // icon: viewModel.pinIcon,
            icon: BitmapDescriptor.defaultMarker,
            position: viewModel.latLng!)
      },
      initialCameraPosition: CameraPosition(
          target: viewModel.latLng!, tilt: 59.440717697143555, zoom: 16),
    );
  }
}
