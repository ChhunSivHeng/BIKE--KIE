import 'package:flutter/material.dart';

import '../../../../utils/app_theme.dart';
import '../../../widgets/display/alert_card.dart';
import '../../../widgets/pass_info_card.dart';

/// Displays the user's active pass details, or an alert if they have none.
///
/// Accepts plain values — no ViewModel dependency — so it stays a pure
/// presentational widget that is easy to test and reuse.
class RentingPassSection extends StatelessWidget {
  final bool hasActivePass;
  final String? passType;
  final String? passEndDate;

  const RentingPassSection({
    super.key,
    required this.hasActivePass,
    this.passType,
    this.passEndDate,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasActivePass) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: AlertCard(
          title: 'No Active Pass',
          message: 'You need a pass to rent. Choose an option below.',
          backgroundColor: Color(0xFFFFF3E0),
          borderColor: Color(0xFFFFD54F),
          textColor: Color(0xFFF57C00),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ACTIVE SUBSCRIPTION',
            style: TextStyle(
              color: AppColors.gray600,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          PassInfoCard(
            passType: passType ?? 'Unknown Pass',
            details: [
              PassDetailItem(label: 'Valid Until', value: passEndDate ?? 'N/A'),
              PassDetailItem(label: 'Renting Fee', value: 'INCLUDED'),
            ],
          ),
        ],
      ),
    );
  }
}
