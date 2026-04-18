import 'package:flutter/material.dart';
import '../../../utils/app_theme.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key, this.title = 'BIKE-KIE'});

  final String title;

  static const double height = 56;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }
}
