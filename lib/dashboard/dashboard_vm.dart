import 'package:flutter/material.dart';
import 'package:maps_integration/dashboard/dashboard_model.dart';
import 'package:maps_integration/dashboard/current_location/current_location_vu.dart';
import 'package:maps_integration/dashboard/edit_location/edit_location_vu.dart';
import 'package:maps_integration/dashboard/polyline/polyline_vu.dart';
import 'package:maps_integration/utils.dart';
import 'package:stacked/stacked.dart';

class DashboardVM extends BaseViewModel {
  List<DashBoardModel> dashboardGrid = [
    DashBoardModel('Current Location', Icons.location_on_sharp),
    DashBoardModel('Edit your Location', Icons.edit_location_alt_sharp),
    DashBoardModel('polyline between locations', Icons.polyline),
    DashBoardModel('Location Searching', Icons.location_searching),
  ];

  onClickGridItem(BuildContext context, String title) {
    switch (title) {
      case 'Current Location':
        Utils.pushRoute(context, const CurrentLocationVU());
        break;
      case 'Edit your Location':
        Utils.pushRoute(context, const EditLocationVU());
        break;
      case 'polyline between locations':
        Utils.pushRoute(context, const PolylineVU());
        break;
      default:
    }
  }
}
