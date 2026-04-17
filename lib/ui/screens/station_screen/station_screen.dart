import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_model/station_model.dart';
import 'widgets/station_content.dart';

class StationScreen extends StatelessWidget {
  const StationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StationViewModel(),
      child: const StationContent(),
    );
  }
}
