import 'package:flutter/material.dart';
import 'package:maps_integration/location_fields/chi_location_picker/polyline.dart';
import 'package:maps_integration/location_fields/chi_search_location_picker/chi_search_location_widget.dart';

import 'package:maps_integration/utils.dart';

// ignore: must_be_immutable
class CHISearchLocationPicker extends StatelessWidget {
  CHISearchLocationPicker({
    super.key,
    required this.pickerTitle,
    required this.onGetDirectionPolyline,
  });
  String pickerTitle;
  final Function(DirectionPolyline directionPolyline) onGetDirectionPolyline;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return GestureDetector(
        onTap: () {
          Utils.pushRoute(context, const CHISearchLocationWidget())
              .then((value) async {
            if (value != null) {
              pickerTitle = '${value.distance}, ${value.duration}';
              onGetDirectionPolyline(value);
              setState(() {});
            }
          });
        },
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: Text(pickerTitle, maxLines: 2)),
                const Icon(Icons.location_searching_rounded)
              ],
            ),
          ),
        ),
      );
    });
  }
}
