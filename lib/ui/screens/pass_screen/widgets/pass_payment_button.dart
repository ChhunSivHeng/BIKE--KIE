import 'package:flutter/material.dart';

import '../../../../utils/app_theme.dart';

class PassPaymentButton extends StatelessWidget {
  final bool isProcessing;
  final Future<void> Function() onProcessPayment;

  const PassPaymentButton({
    super.key,
    required this.isProcessing,
    required this.onProcessPayment,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isProcessing ? null : onProcessPayment,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        isProcessing ? 'Processing...' : 'Process Payment',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
