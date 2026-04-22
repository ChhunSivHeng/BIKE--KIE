import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class PassInfoCard extends StatelessWidget {
  final String passType;
  final List<PassDetailItem> details;
  final Color borderColor;
  final Color backgroundColor;
  final double borderRadius;
  final double shadowBlurRadius;

  const PassInfoCard({
    super.key,
    required this.passType,
    required this.details,
    this.borderColor = AppColors.primary,
    this.backgroundColor = Colors.white,
    this.borderRadius = 12,
    this.shadowBlurRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.1),
            blurRadius: shadowBlurRadius,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            passType,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: details
                .map((detail) => _PassDetailItemWidget(detail: detail))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class PassDetailItem {
  final String label;
  final String value;

  PassDetailItem({required this.label, required this.value});
}

class _PassDetailItemWidget extends StatelessWidget {
  final PassDetailItem detail;

  const _PassDetailItemWidget({required this.detail});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          detail.label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.gray600,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          detail.value,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
