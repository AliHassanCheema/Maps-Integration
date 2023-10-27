import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:maps_integration/dashboard/search_location/search_location_vm.dart';
import 'package:stacked/stacked.dart';

class SearchLocationVU extends StackedView<SearchLocationVM> {
  const SearchLocationVU({super.key, this.mapType = MapType.normal});
  final MapType mapType;

  @override
  Widget builder(
      BuildContext context, SearchLocationVM viewModel, Widget? child) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search Location'),
        ),
        body: viewModel.isBusy
            ? const LinearProgressIndicator()
            : Stack(
                children: [
                  _googleMapWidget(viewModel, context),
                  Column(
                    children: [
                      _searchField(viewModel, context),
                      viewModel.coordinates.length < 2
                          ? const SizedBox.shrink()
                          : ElevatedButton(
                              onPressed: () {
                                viewModel.onMakePolyline();
                              },
                              child: const Text('Find Directions')),
                      viewModel.searchLocations.isEmpty
                          ? const SizedBox.shrink()
                          : searchList(viewModel),
                    ],
                  ),
                ],
              ),
        bottomSheet: viewModel.distance != null && viewModel.duration != null
            ? _pollyLineBottomSheet(viewModel)
            : const SizedBox.shrink());
  }

  @override
  SearchLocationVM viewModelBuilder(BuildContext context) {
    final vm = SearchLocationVM();
    vm.onGetCurrentLocation(context);
    return vm;
  }

  Widget _pollyLineBottomSheet(SearchLocationVM viewModel) {
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 127, 99, 175),
          borderRadius: BorderRadius.circular(12)),
      height: 100,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _bottomSheetRow('Total Distance : ', viewModel.distance ?? '--'),
            _bottomSheetRow('Time : ', viewModel.duration ?? '--'),
          ],
        ),
      ),
    );
  }

  Widget searchList(SearchLocationVM viewModel) {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: viewModel.searchLocations.length,
          itemBuilder: (context, index) {
            final result = viewModel.searchLocations[index];
            return ListTile(
              onTap: () {
                viewModel.onClickSearchedItem(result, context);
              },
              title: Text(result.name),
              subtitle: Text(result.address),
            );
          },
        ),
      ),
    );
  }

  Widget _searchField(SearchLocationVM viewModel, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 52,
        child: TextFormField(
          controller: viewModel.searchController,
          textAlignVertical: TextAlignVertical.bottom,
          decoration: InputDecoration(
              suffixIcon: const Icon(Icons.search),
              fillColor: Colors.white,
              filled: true,
              enabledBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
              focusedBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
              hintText: 'Search for a place'),
          onChanged: (value) {
            viewModel.onSearch(value, context);
          },
        ),
      ),
    );
  }

  Widget _googleMapWidget(SearchLocationVM viewModel, BuildContext context) {
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
        target: viewModel.coordinates.last,
      ),
    );
  }

  Widget _bottomSheetRow(String heading, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          heading,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }
}
