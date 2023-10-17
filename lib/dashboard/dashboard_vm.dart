import 'package:flutter/material.dart';
import 'package:maps_integration/dashboard/dashboard_model.dart';
import 'package:maps_integration/maps/maps_vu.dart';
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
        Utils.pushRoute(context, const MapsVU());
        break;
      default:
    }
  }
}
