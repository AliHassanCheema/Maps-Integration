import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_integration/dashboard/dashboard_model.dart';
import 'package:maps_integration/dashboard/current_location/current_location_vu.dart';
import 'package:maps_integration/dashboard/edit_location/edit_location_vu.dart';
import 'package:maps_integration/dashboard/polyline/polyline_vu.dart';
import 'package:maps_integration/dashboard/search_location/search_location_vu.dart';
import 'package:maps_integration/utils.dart';
import 'package:stacked/stacked.dart';

class DashboardVM extends BaseViewModel {
  LatLng? originLatLng;
  LatLng? destinationLatLng;
  String originLocation = 'Select Your origin';
  String destinationLocation = 'Select Your Destination';
  MapType defaultMapType = MapType.normal;
  bool trafficEnabled = false;
  bool indoorViewEnabled = false;
  bool liteModeEnabled = false;
  List<MapType> mapTypes = [
    MapType.none,
    MapType.normal,
    MapType.satellite,
    MapType.hybrid,
    MapType.terrain
  ];
  List<DashBoardModel> dashboardGrid = [
    DashBoardModel('Current Location', Icons.location_on_sharp),
    DashBoardModel('Select Location', Icons.edit_location_alt_sharp),
    DashBoardModel('Polyline Location', Icons.polyline),
    DashBoardModel('Search Location', Icons.location_searching),
  ];
  onChangeMapType(MapType? type) {
    defaultMapType = type!;
    notifyListeners();
  }

  onCheckPermission(BuildContext context) async {
    await Utils.getCurrentPosition(context);
  }

  onClickGridItem(BuildContext context, String title) {
    switch (title) {
      case 'Current Location':
        Utils.pushRoute(
            context,
            CurrentLocationVU(
                mapType: defaultMapType,
                liteModeEnabled: liteModeEnabled,
                trafficEnabled: trafficEnabled,
                indoorViewEnabled: indoorViewEnabled));
        break;
      case 'Select Location':
        Utils.pushRoute(
            context,
            EditLocationVU(
                mapType: defaultMapType,
                liteModeEnabled: liteModeEnabled,
                trafficEnabled: trafficEnabled,
                indoorViewEnabled: indoorViewEnabled));
        break;
      case 'Polyline Location':
        Utils.pushRoute(
            context,
            PolylineVU(
                mapType: defaultMapType,
                liteModeEnabled: liteModeEnabled,
                trafficEnabled: trafficEnabled,
                indoorViewEnabled: indoorViewEnabled));
        break;
      case 'Search Location':
        Utils.pushRoute(context, SearchLocationVU(mapType: defaultMapType));
        break;

      default:
    }
  }
}
