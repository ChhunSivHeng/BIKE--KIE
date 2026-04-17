import 'package:flutter/material.dart';
import '../../../../utils/app_theme.dart';
import 'booking_theme.dart';
import 'booking_constants.dart';

/// Map placeholder badge showing "MAP VIEW" label
class MapPlaceholderBadge extends StatelessWidget {
  const MapPlaceholderBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(BookingTheme.radiusSmall),
      ),
      child: const Text(
        BookingConstants.mapView,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
