import 'package:flutter/material.dart';

import '../../../../../model/pass.dart';
import '../../../../utils/app_theme.dart';

class PassStatusCard extends StatelessWidget {
  final Pass? activePass;
  final Pass? selectedPass;
  final bool isProcessingPayment;

  const PassStatusCard({
    super.key,
    required this.activePass,
    required this.selectedPass,
    required this.isProcessingPayment,
  });

  String _activePassTitle(Pass pass) {
    switch (pass.type) {
      case PassType.day:
        return 'Daily Explorer';
      case PassType.monthly:
        return 'Monthly Explorer';
      case PassType.annual:
        return 'Annual Explorer';
    }
  }

  String _formatDate(DateTime date) {
    const months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final pass = activePass ?? selectedPass;

    if (pass == null) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F7),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.gray300),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'INVALID PASS',
              style: TextStyle(
                color: AppColors.gray500,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'No Subscription',
              style: TextStyle(
                color: AppColors.gray600,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 3),
            Text(
              'Subscribe to start riding',
              style: TextStyle(
                color: AppColors.gray500,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            activePass != null ? 'CURRENT ACTIVE PASS' : 'SELECTED PLAN',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _activePassTitle(pass),
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Expires on ${_formatDate(pass.endDate)}',
            style: const TextStyle(
              color: AppColors.gray600,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isProcessingPayment) ...[
            const SizedBox(height: 10),
            Row(
              children: const [
                SizedBox(
                  height: 14,
                  width: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 10),
                Text(
                  'Processing payment...',
                  style: TextStyle(
                    color: AppColors.gray600,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
