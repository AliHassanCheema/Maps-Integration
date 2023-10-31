import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_integration/dashboard/location_picker/google_map.dart';
import 'package:maps_integration/utils.dart';

// ignore: must_be_immutable
class CHILocationPicker extends StatelessWidget {
  CHILocationPicker({
    super.key,
    required this.pickerTitle,
    required this.onGetLatLng,
    this.selectedLatLng,
  });
  String pickerTitle;
  LatLng? selectedLatLng;
  final Function(LatLng latlng) onGetLatLng;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return GestureDetector(
        onTap: () {
          Utils.pushRoute(
              context,
              CHIGoogleMap(
                selectedLatLng: selectedLatLng,
              )).then((value) async {
            if (value != null) {
              selectedLatLng = value;
              onGetLatLng(selectedLatLng!);
              pickerTitle = await Utils.getAddressFromCoordinates(value);
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
                const Icon(Icons.location_on_outlined)
              ],
            ),
          ),
        ),
      );
    });
  }
}
