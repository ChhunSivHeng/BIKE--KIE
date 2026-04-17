import 'package:flutter/material.dart';
import '../../../../utils/app_theme.dart';
import 'booking_theme.dart';
import 'map_placeholder_badge.dart';

/// Map preview section for booking
class MapPreviewSection extends StatelessWidget {
  const MapPreviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: BookingTheme.mapHeight,
      margin: const EdgeInsets.symmetric(horizontal: BookingTheme.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(BookingTheme.radiusLarge),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.map, size: 48, color: AppColors.gray400),
          const Positioned(
            bottom: BookingTheme.paddingMedium,
            left: BookingTheme.paddingMedium,
            child: MapPlaceholderBadge(),
          ),
        ],
      ),
    );
  }
}
