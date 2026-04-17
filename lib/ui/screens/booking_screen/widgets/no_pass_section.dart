import 'package:flutter/material.dart';
import 'booking_theme.dart';
import 'booking_constants.dart';
import 'warning_alert.dart';

/// Shows warning when user has no active pass
class NoPassSection extends StatelessWidget {
  const NoPassSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: BookingTheme.paddingLarge,
      ),
      child: WarningAlert(
        title: BookingConstants.noActivePass,
        message: BookingConstants.noPassWarning,
        backgroundColor: const Color(0xFFFFF3E0),
        borderColor: const Color(0xFFFFD54F),
        textColor: const Color(0xFFF57C00),
      ),
    );
  }
}
