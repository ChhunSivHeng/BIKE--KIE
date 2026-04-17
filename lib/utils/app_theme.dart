import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFC41E3A);
  static const Color primaryDark = Color(0xFFA01830);
  static const Color primaryLight = Color(0xFFE63946);
  static const Color primaryVeryLight = Color(0xFFFAECED);

  static const Color accent = Color(0xFFC41E3A);
  static const Color accentLight = Color(0xFFFFDFE5);
  static const Color success = Color(0xFF059669);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFC41E3A);

  static const Color black = Color(0xFF0F172A);
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray50 = Color(0xFFF8FAFC);
  static const Color gray100 = Color(0xFFF1F5F9);
  static const Color gray200 = Color(0xFFE2E8F0);
  static const Color gray300 = Color(0xFFCBD5E1);
  static const Color gray400 = Color(0xFF94A3B8);
  static const Color gray500 = Color(0xFF64748B);
  static const Color gray600 = Color(0xFF475569);
  static const Color gray700 = Color(0xFF334155);

  static const Color success_bg = Color(0xFFECFDF5);
  static const Color warning_bg = Color(0xFFFEF3C7);
  static const Color error_bg = Color(0xFFFAECED);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFC41E3A), Color(0xFFE63946)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFC41E3A), Color(0xFFE63946)],
  );
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.white,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      secondary: AppColors.primary,
      onSecondary: AppColors.white,
      error: AppColors.error,
      surface: AppColors.white,
      onSurface: AppColors.black,
      tertiaryContainer: AppColors.primaryVeryLight,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.black),
      titleTextStyle: TextStyle(
        color: AppColors.black,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.gray400,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: AppColors.black,
        fontSize: 36,
        fontWeight: FontWeight.w800,
        letterSpacing: -1,
      ),
      displayMedium: TextStyle(
        color: AppColors.black,
        fontSize: 32,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
      displaySmall: TextStyle(
        color: AppColors.black,
        fontSize: 28,
        fontWeight: FontWeight.w800,
      ),
      headlineLarge: TextStyle(
        color: AppColors.black,
        fontSize: 32,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        color: AppColors.black,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      headlineSmall: TextStyle(
        color: AppColors.black,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: TextStyle(
        color: AppColors.black,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        color: AppColors.black,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: TextStyle(
        color: AppColors.black,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: AppColors.gray700,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.6,
      ),
      bodyMedium: TextStyle(
        color: AppColors.gray600,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        color: AppColors.gray500,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
      ),
      labelLarge: TextStyle(
        color: AppColors.black,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
      labelMedium: TextStyle(
        color: AppColors.gray600,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
      labelSmall: TextStyle(
        color: AppColors.gray500,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
      ),
    ),
    // Elevated Button - Primary Red
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
        surfaceTintColor: AppColors.primary,
      ),
    ),
    // Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    ),
    // Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    ),
    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.gray50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.gray200, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.gray200, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      hintStyle: const TextStyle(
        color: AppColors.gray400,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      labelStyle: const TextStyle(
        color: AppColors.primary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      prefixIconColor: AppColors.primary,
      suffixIconColor: AppColors.primary,
      errorStyle: const TextStyle(
        color: AppColors.error,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
    // Slider Theme
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.primary,
      inactiveTrackColor: AppColors.gray200,
      thumbColor: AppColors.primary,
      overlayColor: AppColors.primary.withOpacity(0.2),
      trackHeight: 6,
      thumbShape: const RoundSliderThumbShape(
        elevation: 0,
        enabledThumbRadius: 10,
      ),
      valueIndicatorColor: AppColors.primary,
      valueIndicatorTextStyle: const TextStyle(
        color: AppColors.white,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    ),
    // Card Theme
    cardTheme: CardThemeData(
      color: AppColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.gray200, width: 1),
      ),
      margin: const EdgeInsets.all(0),
      surfaceTintColor: AppColors.primary,
    ),
    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return AppColors.gray200;
      }),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
    ),
    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: AppColors.gray200,
      thickness: 1,
      space: 16,
    ),
    // Icon Theme
    iconTheme: const IconThemeData(
      color: AppColors.primary,
      size: 24,
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: const Color(0xFF1A202C),
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      secondary: AppColors.primary,
      onSecondary: AppColors.white,
      error: AppColors.error,
      surface: const Color(0xFF2D3748),
      onSurface: AppColors.white,
    ),
  );
}

/// Spacing constants for consistent layout
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

/// Border radius constants
class AppRadius {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double full = 9999;
}

/// Shadow constants for depth and elevation
class AppShadows {
  static const List<BoxShadow> none = [];

  static const List<BoxShadow> sm = [
    BoxShadow(color: Color(0x0A000000), blurRadius: 2, offset: Offset(0, 1)),
  ];

  static const List<BoxShadow> md = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 6, offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> lg = [
    BoxShadow(color: Color(0x25000000), blurRadius: 12, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> xl = [
    BoxShadow(color: Color(0x33000000), blurRadius: 20, offset: Offset(0, 8)),
  ];

  /// Red-branded shadow for CTAs and important elements
  static List<BoxShadow> redGlow = [
    BoxShadow(
      color: AppColors.primary.withOpacity(0.3),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: AppColors.primary.withOpacity(0.15),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  /// Subtle red shadow
  static List<BoxShadow> redSubtle = [
    BoxShadow(
      color: AppColors.primary.withOpacity(0.1),
      blurRadius: 12,
      offset: const Offset(0, 6),
    ),
  ];
}

/// Button styles constants
class AppButtonStyles {
  static final ButtonStyle pillStyle = ElevatedButton.styleFrom(
    shape: const StadiumBorder(),
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
  );

  static final ButtonStyle squareStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );
}
