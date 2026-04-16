import 'package:flutter/material.dart';

import 'ui/screens/map_screen/map_content.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BikeKieApp());
}

class BikeKieApp extends StatelessWidget {
  const BikeKieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BIKE-KIE',
      home: MapContent(), // shows the map page on launch
    );
  }
}
