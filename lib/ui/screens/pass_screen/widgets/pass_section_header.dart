import 'package:flutter/material.dart';

import '../../../../utils/app_theme.dart';

class PassSectionHeader extends StatelessWidget {
  const PassSectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pass Selection',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Choose the membership that fits your rhythm.',
          style: TextStyle(
            color: AppColors.gray500,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
