import 'package:flutter/material.dart';
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
    return DashboardVM();
  }

  Widget _dashboardGrid(DashboardVM viewModel) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
          itemCount: viewModel.dashboardGrid.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
          itemBuilder: (context, index) {
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
                    Icon(viewModel.dashboardGrid[index].icon,
                        color: Colors.red),
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
          }),
    );
  }
}