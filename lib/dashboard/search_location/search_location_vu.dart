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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: viewModel.searchController,
              decoration:
                  const InputDecoration(labelText: 'Search for a place'),
              onChanged: (value) {
                viewModel.onSearch(value, context);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.searchResults.length,
              itemBuilder: (context, index) {
                final result = viewModel.searchResults[index];
                return ListTile(
                  title: Text(result['name']),
                  subtitle: Text(result['formatted_address']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  SearchLocationVM viewModelBuilder(BuildContext context) {
    return SearchLocationVM();
  }
}
