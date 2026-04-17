import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_model/map_view_model.dart';
import 'widgets/map_content.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MapViewModel()..loadStations(),
      child: const MapContent(),
    );
  }
}
