import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/station.dart';
import 'view_model/booking_model.dart';
import 'widgets/booking_content.dart';

class BookingScreen extends StatelessWidget {
  final Station? station;

  const BookingScreen({super.key, this.station});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingViewModel(station: station),
      child: const BookingContent(),
    );
  }
}
