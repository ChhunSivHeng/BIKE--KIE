import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

/// Reusable location badge component
/// Displays a location icon in a rounded container
class LocationBadge extends StatelessWidget {
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final double size;
  final double iconSize;
  final double borderRadius;

  const LocationBadge({
    super.key,
    this.backgroundColor = AppColors.white,
    this.borderColor = AppColors.gray200,
    this.iconColor = AppColors.primary,
    this.size = 44,
    this.iconSize = 22,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor),
      ),
      child: Center(
        child: Icon(Icons.location_on, color: iconColor, size: iconSize),
      ),
    );
  }
}
