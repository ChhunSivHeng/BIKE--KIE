import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

/// Reusable map preview component
/// Displays a placeholder map area with optional badge
class MapPreview extends StatelessWidget {
  final double height;
  final Color backgroundColor;
  final Color borderColor;
  final double borderRadius;
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final String? badgeLabel;
  final VoidCallback? onTap;

  const MapPreview({
    super.key,
    this.height = 160,
    this.backgroundColor = AppColors.gray100,
    this.borderColor = AppColors.gray200,
    this.borderRadius = 12,
    this.icon = Icons.map,
    this.iconColor = AppColors.gray400,
    this.iconSize = 48,
    this.badgeLabel = 'Map Preview',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, size: iconSize, color: iconColor),
            if (badgeLabel != null)
              Positioned(
                bottom: 12,
                left: 12,
                child: _MapBadge(label: badgeLabel!),
              ),
          ],
        ),
      ),
    );
  }
}

/// Small badge component for map preview
class _MapBadge extends StatelessWidget {
  final String label;

  const _MapBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.black,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
