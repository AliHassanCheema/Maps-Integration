import 'package:flutter/material.dart';
import 'package:maps_integration/location_fields/location_fields_vu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maps Integraion',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
            centerTitle: true,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
            backgroundColor: Color.fromARGB(255, 127, 99, 175)),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LocationFieldsVU(),
    );
  }
}
