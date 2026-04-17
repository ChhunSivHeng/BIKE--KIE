import 'package:flutter/material.dart';
import '../../../../utils/app_theme.dart';

/// Booking screen text styles and spacing
class BookingTheme {
  // Text Styles
  static const TextStyle sectionLabel = TextStyle(
    color: AppColors.gray600,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static const TextStyle passTypeName = TextStyle(
    color: AppColors.black,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );

  static const TextStyle passDetailLabel = TextStyle(
    color: AppColors.gray600,
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle passDetailValue = TextStyle(
    color: AppColors.black,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle warningTitle = TextStyle(
    color: Color(0xFFF57C00),
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle buttonText = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
  );

  // Spacing
  static const double paddingSmall = 8;
  static const double paddingMedium = 12;
  static const double paddingLarge = 16;
  static const double paddingXLarge = 24;

  static const double spacingSmall = 4;
  static const double spacingMedium = 8;
  static const double spacingLarge = 12;
  static const double spacingXLarge = 20;
  static const double spacingXXLarge = 24;

  // Border Radius
  static const double radiusSmall = 4;
  static const double radiusMedium = 8;
  static const double radiusLarge = 12;

  // Heights
  static const double buttonHeight = 52;
  static const double mapHeight = 160;
  static const double appBarHeight = 56;
}
