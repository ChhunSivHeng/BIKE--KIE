import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class AppAvatar extends StatelessWidget {
  final String name;
  final String? email;
  final double size;
  final IconData icon;

  const AppAvatar({
    super.key,
    required this.name,
    this.email,
    this.size = 80,
    this.icon = Icons.person,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withOpacity(0.15),
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: Icon(icon, size: size * 0.5, color: AppColors.primary),
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        if (email != null) ...[
          const SizedBox(height: 6),
          Text(
            email!,
            style: const TextStyle(fontSize: 13, color: AppColors.gray600),
          ),
        ],
      ],
    );
  }
}
