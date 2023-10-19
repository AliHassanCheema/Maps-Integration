import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_integration/dashboard/dashboard_vm.dart';
import 'package:stacked/stacked.dart';

class DashboardVU extends StackedView<DashboardVM> {
  const DashboardVU({super.key});

  @override
  Widget builder(BuildContext context, DashboardVM viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: const Text('Maps DashBoard')),
      body: _dashboardGrid(viewModel),
    );
  }

  @override
  DashboardVM viewModelBuilder(BuildContext context) {
    final vm = DashboardVM();
    vm.onCheckPermission(context);
    return vm;
  }

  Widget _dashboardGridCell(
      DashboardVM viewModel, BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        viewModel.onClickGridItem(
            context, viewModel.dashboardGrid[index].title);
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(viewModel.dashboardGrid[index].icon, color: Colors.red),
            const SizedBox(height: 12),
            Text(
              viewModel.dashboardGrid[index].title,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _dashboardGrid(DashboardVM viewModel) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Map type'),
          _mapTypeDropdown(viewModel),
          _switchButton((v) {
            viewModel.trafficEnabled = v;
            viewModel.notifyListeners();
          }, viewModel.trafficEnabled, 'Show Traffic'),
          _switchButton((v) {
            viewModel.indoorViewEnabled = v;
            viewModel.notifyListeners();
          }, viewModel.indoorViewEnabled, 'Show Indoor View'),
          if (Platform.isAndroid)
            _switchButton((v) {
              viewModel.liteModeEnabled = v;
              viewModel.notifyListeners();
            }, viewModel.liteModeEnabled, 'Show in lite mode'),
          Expanded(
            child: GridView.builder(
                itemCount: viewModel.dashboardGrid.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0),
                itemBuilder: (context, index) {
                  return _dashboardGridCell(viewModel, context, index);
                }),
          ),
        ],
      ),
    );
  }

  SwitchListTile _switchButton(
      void Function(bool)? onChanged, bool switchVal, String title) {
    return SwitchListTile(
      value: switchVal,
      onChanged: onChanged,
      title: Text(title),
    );
  }

  DropdownButton<MapType> _mapTypeDropdown(DashboardVM viewModel) {
    return DropdownButton(
        isExpanded: true,
        value: viewModel.defaultMapType,
        items: viewModel.mapTypes.map((MapType mapType) {
          return DropdownMenuItem<MapType>(
            value: mapType,
            child: Text(mapType.toString().split('.').last.toUpperCase()),
          );
        }).toList(),
        onChanged: viewModel.onChangeMapType);
  }
}
