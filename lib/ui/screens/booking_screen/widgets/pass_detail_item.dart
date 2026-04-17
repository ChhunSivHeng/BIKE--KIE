import 'package:flutter/material.dart';
import 'booking_theme.dart';

/// Reusable row for displaying pass detail (label + value)
class PassDetailItem extends StatelessWidget {
  final String label;
  final String value;

  const PassDetailItem({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: BookingTheme.passDetailLabel),
        const SizedBox(height: BookingTheme.spacingSmall),
        Text(value, style: BookingTheme.passDetailValue),
      ],
    );
  }
}
