import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

/// AppSection - Minimal section header component
class AppSection extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Widget? child;

  const AppSection({super.key, required this.title, this.icon, this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
            ],
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ?child,
      ],
    );
  }
}
