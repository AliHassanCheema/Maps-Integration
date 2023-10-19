import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maps_integration/secrets.dart';
import 'package:maps_integration/utils.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class SearchLocationVM extends BaseViewModel {
  final TextEditingController searchController = TextEditingController();
  List<dynamic> searchResults = [];
  Future<void> onSearch(String query, context) async {
    if (query.isEmpty) {
      searchResults.clear();
      notifyListeners();
      return;
    }

    final response = await http.get(
        Uri.parse(
            'https://maps.googleapis.com/maps/api/place/textsearch/json?key=$googleMapsApiKey&query=$query'),
        headers: {'Accept': 'application/json'});

    if (response.statusCode == 200) {
      final resp = json.decode(response.body);
      if (resp['status'] == 'OK') {
        searchResults = resp['results'];
        notifyListeners();
      } else {
        Utils.showSnackBar(context, resp['error_message']);
      }
    }
  }
}
