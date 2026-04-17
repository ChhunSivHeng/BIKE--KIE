import 'package:flutter/material.dart';
import '../../../../model/station.dart';
import '../../../../utils/app_theme.dart';

/// Reusable widget for station information card
class StationInfoCard extends StatelessWidget {
  final Station station;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onClose;

  const StationInfoCard({
    super.key,
    required this.station,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Station Details',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          Row(
            children: [
              // Principle 9: Help & Documentation - Add tooltip
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? AppColors.primary : AppColors.gray400,
                ),
                onPressed: onToggleFavorite,
                tooltip: isFavorite
                    ? 'Remove from favorites'
                    : 'Add to favorites',
              ),
              // Principle 3: User Control & Freedom - Easy close
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.gray600),
                onPressed: onClose,
                tooltip: 'Close',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
