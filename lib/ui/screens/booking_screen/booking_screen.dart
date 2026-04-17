import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_model/booking_model.dart';
import 'widgets/booking_content.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingViewModel(),
      child: const BookingContent(),
    );
  }
}
