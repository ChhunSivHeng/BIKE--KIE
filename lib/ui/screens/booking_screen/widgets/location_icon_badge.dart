import 'package:flutter/material.dart';
import '../../../../utils/app_theme.dart';

/// Location icon badge component
class LocationIconBadge extends StatelessWidget {
  final double size;
  final double iconSize;

  const LocationIconBadge({super.key, this.size = 44, this.iconSize = 22});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.location_on, color: AppColors.primary, size: iconSize),
    );
  }
}
