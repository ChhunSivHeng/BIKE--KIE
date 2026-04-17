import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/stationRepository/station_repository.dart';
import 'view_model/map_view_model.dart';
import 'widgets/map_content.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stationRepository = context.read<StationRepository>();
    return ChangeNotifierProvider(
      create: (_) => MapViewModel(stationRepository),
      child: const MapContent(),
    );
  }
}
