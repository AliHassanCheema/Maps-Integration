import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_integration/utils.dart';
import 'package:stacked/stacked.dart';

class LocationFieldsVM extends BaseViewModel {
  LatLng? selectedLatLng;
  String searchLoctionTitle = 'Search Location';
  String selectedLocation = 'Pick Your Location';
  String originAddress = 'Select Origin Address';
  String destinationAddress = 'Select Destination Address';

  onCheckPermission(BuildContext context) async {
    await Utils.getCurrentPosition(context);
  }
}
