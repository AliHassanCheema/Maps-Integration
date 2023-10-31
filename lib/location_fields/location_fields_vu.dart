import 'package:flutter/material.dart';
import 'package:maps_integration/location_fields/chi_direction_picker/chi_direction_picker.dart';
import 'package:maps_integration/location_fields/chi_location_picker/chi_location_picker.dart';
import 'package:maps_integration/location_fields/chi_search_location_picker/chi_search_location.dart';
import 'package:maps_integration/location_fields/location_fields_vm.dart';
import 'package:maps_integration/utils.dart';
import 'package:stacked/stacked.dart';

class LocationFieldsVU extends StackedView<LocationFieldsVM> {
  const LocationFieldsVU({super.key});

  @override
  Widget builder(
      BuildContext context, LocationFieldsVM viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location Pickers')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CHILocationPicker(
              selectedLatLng: viewModel.selectedLatLng,
              pickerTitle: viewModel.selectedLocation,
              onGetLatLng: (latlng) async {
                viewModel.selectedLatLng = latlng;
                viewModel.selectedLocation =
                    await Utils.getAddressFromCoordinates(latlng);
                viewModel.notifyListeners();
              },
            ),
            CHISearchLocationPicker(
              pickerTitle: viewModel.searchLoctionTitle,
              onGetDirectionPolyline: (directionPolyline) {
                viewModel.searchLoctionTitle =
                    '${directionPolyline.distance}, ${directionPolyline.duration}';
              },
            ),
            CHIDirectionPicker(
              onGetDirectionPolyline: (directionPolyline) {},
            ),
          ],
        ),
      ),
    );
  }

  @override
  LocationFieldsVM viewModelBuilder(BuildContext context) {
    final vm = LocationFieldsVM();
    vm.onCheckPermission(context);
    return vm;
  }
}
