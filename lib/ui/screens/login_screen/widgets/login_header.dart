import 'package:flutter/material.dart';
import '../../../../utils/app_theme.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.1),
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: const Icon(
              Icons.two_wheeler,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'Bikkie',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),

          const Text(
            'Your Urban Mobility Solution',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.gray600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
