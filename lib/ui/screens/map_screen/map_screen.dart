import 'package:flutter/material.dart';
import 'widgets/map_content.dart';

/// MapScreen no longer owns the MapViewModel.
/// The ViewModel is created once in BikeApp and provided via
/// ChangeNotifierProvider<MapViewModel>.value so it survives
/// tab switches and navigation pops.
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MapContent();
  }
}
