import 'package:flutter/material.dart';
import '../../model/station.dart';
import '../../utils/app_theme.dart';
import 'location_badge.dart';

/// Reusable station information card component
/// Displays station name, location, and availability info
class StationInfoCard extends StatelessWidget {
  final Station station;
  final String? locationText;
  final Color backgroundColor;
  final Color borderColor;
  final double borderRadius;
  final EdgeInsets padding;

  const StationInfoCard({
    super.key,
    required this.station,
    this.locationText,
    this.backgroundColor = AppColors.gray50,
    this.borderColor = AppColors.gray200,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          const LocationBadge(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  station.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  locationText ??
                      'Sector 1 • ${station.bikeAmounts} bikes available',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.gray600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
