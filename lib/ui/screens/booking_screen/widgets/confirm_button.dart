import 'package:flutter/material.dart';
import '../../../../utils/app_theme.dart';
import 'booking_theme.dart';
import 'booking_constants.dart';

/// Confirm booking button widget
class ConfirmButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ConfirmButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: BookingTheme.paddingLarge,
      ),
      child: SizedBox(
        width: double.infinity,
        height: BookingTheme.buttonHeight,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(BookingTheme.radiusLarge),
            ),
          ),
          child: const Text(
            BookingConstants.confirmBooking,
            style: BookingTheme.buttonText,
          ),
        ),
      ),
    );
  }
}
