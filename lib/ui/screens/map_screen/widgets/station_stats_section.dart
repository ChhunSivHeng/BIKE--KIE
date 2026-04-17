import 'package:flutter/material.dart';
import '../../../../model/station.dart';
import '../../../../utils/app_theme.dart';

/// Reusable widget for station statistics section
class StationStatsSection extends StatelessWidget {
  final Station station;
  final bool isLowAvailability;

  const StationStatsSection({
    super.key,
    required this.station,
    required this.isLowAvailability,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Principle 1: Visibility - Stats with icon
        Row(
          children: [
            Expanded(
              child: _StatCard(
                value: '${station.bikeAmounts}',
                label: 'Bikes Available',
                icon: Icons.pedal_bike,
                isWarning: isLowAvailability,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                value: '${station.totalSlots}',
                label: 'Total Slots',
                icon: Icons.local_parking,
              ),
            ),
          ],
        ),
        // Principle 1: Visibility - Low availability warning
        if (isLowAvailability)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange[700], size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Only ${station.bikeAmounts} bike${station.bikeAmounts > 1 ? 's' : ''} left',
                      style: TextStyle(
                        color: Colors.orange[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Reusable stat card component
class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final bool isWarning;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isWarning ? Colors.orange.withOpacity(0.08) : AppColors.gray50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isWarning ? Colors.orange.withOpacity(0.3) : AppColors.gray100,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isWarning ? Colors.orange : AppColors.primary,
            size: 20,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: isWarning ? Colors.orange : AppColors.primary,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.gray600,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.1,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
