import 'package:flutter/material.dart';
import '../../../../utils/app_theme.dart';
import 'booking_theme.dart';
import 'booking_constants.dart';

/// Custom AppBar for booking screen
class BookingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BookingAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(BookingTheme.appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        BookingConstants.screenTitle,
        style: TextStyle(
          color: AppColors.black,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      centerTitle: true,
    );
  }
}
