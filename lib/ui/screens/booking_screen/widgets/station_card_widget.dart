import 'package:flutter/material.dart';
import '../../../../model/station.dart';
import '../../../../utils/app_theme.dart';
import 'booking_theme.dart';
import 'booking_utils.dart';
import 'location_icon_badge.dart';

/// Station details card for booking
class StationCardWidget extends StatelessWidget {
  final Station station;

  const StationCardWidget({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: BookingTheme.paddingLarge,
      ),
      child: Container(
        padding: const EdgeInsets.all(BookingTheme.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.gray50,
          borderRadius: BorderRadius.circular(BookingTheme.radiusLarge),
          border: Border.all(color: AppColors.gray200),
        ),
        child: Row(
          children: [
            const LocationIconBadge(),
            const SizedBox(width: BookingTheme.spacingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    station.name,
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: BookingTheme.spacingSmall),
                  Text(
                    BookingUtils.getLocationText(station.availableBikes),
                    style: TextStyle(
                      color: AppColors.gray600,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
