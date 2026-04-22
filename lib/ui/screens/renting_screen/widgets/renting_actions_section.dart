import 'package:flutter/material.dart';
import '../../../../utils/app_theme.dart';
import '../../../widgets/app_button.dart';

class RentingActionSection extends StatelessWidget {
  final bool hasActiveBike;
  final bool hasActivePass;
  final VoidCallback onConfirm;
  final VoidCallback onBrowsePasses;
  final VoidCallback onBuyTicket;
  final VoidCallback? onViewTimer;

  const RentingActionSection({
    super.key,
    required this.hasActiveBike,
    required this.hasActivePass,
    required this.onConfirm,
    required this.onBrowsePasses,
    required this.onBuyTicket,
    this.onViewTimer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _buildButtons(context),
    );
  }

  Widget _buildButtons(BuildContext context) {
    if (hasActiveBike) {
      return Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Row(
              children: const [
                Icon(Icons.timer_outlined, size: 15, color: AppColors.primary),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'You have an active reservation. Go back to the map to see your pickup timer.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppButton(
            label: 'VIEW PICKUP TIMER',
            onPressed:
                onViewTimer ??
                () => Navigator.of(context).popUntil((route) => route.isFirst),
            height: 52,
            borderRadius: 12,
          ),
        ],
      );
    }

    if (hasActivePass) {
      return AppButton(
        label: 'CONFIRM RENTING',
        onPressed: onConfirm,
        height: 52,
        borderRadius: 12,
      );
    }

    return Row(
      children: [
        Expanded(
          child: AppButton(
            label: 'BROWSE PASSES',
            onPressed: onBrowsePasses,
            outlined: true,
            foregroundColor: AppColors.primary,
            height: 52,
            borderRadius: 12,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppButton(
            label: 'BUY TICKET',
            onPressed: onBuyTicket,
            height: 52,
            borderRadius: 12,
          ),
        ),
      ],
    );
  }
}
