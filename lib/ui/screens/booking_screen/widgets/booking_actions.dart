import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/booking_model.dart';
import 'booking_snackbars.dart';
import 'payment_dialog.dart';
import '../../success_screen/success_screen.dart';

/// Handles user actions in booking screen
class BookingActions {
  static void handleConfirmBooking(
    BuildContext context,
    BookingViewModel viewModel,
    VoidCallback onSuccess,
  ) {
    viewModel.confirmBooking();
    
    // Navigate to success screen after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SuccessScreen(),
          ),
        );
      }
    });
  }

  static void handleBrowsePasses(BuildContext context, VoidCallback onReturn) {
    Navigator.pushNamed(context, '/passes').then((_) => onReturn());
  }

  static void handleBuyTicket(BuildContext context) {
    final viewModel = context.read<BookingViewModel>();
    showDialog(
      context: context,
      builder: (dialogContext) => PaymentDialog(
        onConfirm: () {
          viewModel.buySingleTicket();
          BookingSnackbars.showTicketPurchaseSuccess(context);
        },
        onCancel: () {},
      ),
    );
  }
}
