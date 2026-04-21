import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

/// Reusable booking header component
/// Displays title and subtitle based on booking state
class BookingHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  const BookingHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
              titleStyle ??
              const TextStyle(
                color: AppColors.black,
                fontSize: 32,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style:
              subtitleStyle ??
              theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.gray600,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
