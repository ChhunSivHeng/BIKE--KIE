import 'package:flutter/material.dart';

import '../../../../utils/app_theme.dart';
import '../../../widgets/app_button.dart';

/// Renders the correct bottom action button(s) based on user state.
///
/// Three possible states:
///   1. [hasActiveBike] → "START RIDE" (bike already rented)
///   2. [hasActivePass] → "CONFIRM RENTING" (ready to rent)
///   3. neither         → "BROWSE PASSES" + "BUY TICKET" (needs a pass first)
///
/// All callbacks are provided by [RentingContent] — this widget has no
/// dependency on the ViewModel or BuildContext beyond rendering.
class RentingActionSection extends StatelessWidget {
  final bool hasActiveBike;
  final bool hasActivePass;
  final VoidCallback onConfirm;
  final VoidCallback onBrowsePasses;
  final VoidCallback onBuyTicket;

  const RentingActionSection({
    super.key,
    required this.hasActiveBike,
    required this.hasActivePass,
    required this.onConfirm,
    required this.onBrowsePasses,
    required this.onBuyTicket,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _buildButtons(),
    );
  }

  Widget _buildButtons() {
    if (hasActiveBike) {
      return AppButton(
        label: 'START RIDE',
        onPressed: null, // placeholder — wire up when ride tracking is added
        height: 52,
        borderRadius: 12,
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
