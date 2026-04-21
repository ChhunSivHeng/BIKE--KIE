import 'package:flutter/material.dart';

import '../../../utils/app_theme.dart';

class PaymentCardView extends StatelessWidget {
  final String cardNumber;
  final String expiryDate;
  final String cvv;

  const PaymentCardView({
    super.key,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
  });

  String get _formattedCardNumber {
    final digits = cardNumber.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return '•••• •••• •••• ••••';
    }

    final masked = digits.padRight(16, '•');
    return '${masked.substring(0, 4)} ${masked.substring(4, 8)} ${masked.substring(8, 12)} ${masked.substring(12, 16)}';
  }

  String get _formattedExpiry => expiryDate.isEmpty ? 'MM/YY' : expiryDate;

  String get _formattedCvv => cvv.isEmpty ? '***' : cvv.padRight(3, '*');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF111827), Color(0xFF1F2937)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(Icons.credit_card, color: AppColors.white, size: 20),
              Icon(Icons.contactless, color: AppColors.white, size: 18),
            ],
          ),
          const SizedBox(height: 26),
          Text(
            _formattedCardNumber,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 20,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _LabelValue(
                  label: 'EXP',
                  value: _formattedExpiry,
                ),
              ),
              Expanded(
                child: _LabelValue(
                  label: 'CVV',
                  value: _formattedCvv,
                  alignEnd: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LabelValue extends StatelessWidget {
  final String label;
  final String value;
  final bool alignEnd;

  const _LabelValue({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9CA3AF),
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
