import 'package:flutter/material.dart';

import '../../../../utils/app_theme.dart';
import '../../../widgets/pass_info_card.dart';

/// Displays the assigned bike's ID and battery level after renting is confirmed.
///
/// Returns an empty widget when [bikeId] is null (user has no active bike yet).
class RentingBikeSection extends StatelessWidget {
  final String? bikeId;
  final int? batteryLevel;

  const RentingBikeSection({super.key, this.bikeId, this.batteryLevel});

  @override
  Widget build(BuildContext context) {
    if (bikeId == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ASSIGNED BIKE',
            style: TextStyle(
              color: AppColors.gray600,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          PassInfoCard(
            passType: 'Bike ID: $bikeId',
            details: [
              PassDetailItem(
                label: 'Battery Level',
                value: batteryLevel != null
                    ? '$batteryLevel%'
                    : 'N/A (Mechanical)',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
