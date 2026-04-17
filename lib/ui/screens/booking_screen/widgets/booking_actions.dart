import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/booking_model.dart';
import 'booking_snackbars.dart';
import 'payment_dialog.dart';

/// Handles user actions in booking screen
class BookingActions {
  static void handleConfirmBooking(
    BuildContext context,
    BookingViewModel viewModel,
    VoidCallback onSuccess,
  ) {
    viewModel.confirmBooking();
    BookingSnackbars.showBookingSuccess(context);
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        Navigator.pop(context);
        onSuccess();
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
