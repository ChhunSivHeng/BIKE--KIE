import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/booking_model.dart';
import '../widgets/payment_dialog.dart';
import '../../success_screen/success_screen.dart';

/// Show success message for ticket purchase
void _showTicketPurchaseSuccess(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text('✓ Ticket purchased! You can now book a bike.'),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.all(16),
    ),
  );
}

/// Action handlers for booking screen user interactions
///
/// Handles:
/// - Confirm booking: Firebase call → navigate to success
/// - Browse passes: Navigate to passes screen
/// - Buy ticket: Show payment dialog → create ticket in Firebase
class BookingActions {
  /// Confirm booking with Firebase
  ///
  /// Flow:
  /// 1. Call viewModel.confirmBooking() (awaits Firebase)
  /// 2. Call onSuccess() callback for UI update
  /// 3. Navigate to SuccessScreen
  static Future<void> handleConfirmBooking(
    BuildContext context,
    BookingViewModel viewModel,
    VoidCallback onSuccess,
  ) async {
    await viewModel.confirmBooking();
    onSuccess();

    if (!context.mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SuccessScreen()),
    );
  }

  /// Navigate to passes browsing screen
  static void handleBrowsePasses(BuildContext context, VoidCallback onReturn) {
    Navigator.pushNamed(context, '/passes').then((_) => onReturn());
  }

  /// Show payment dialog for single ticket purchase with Firebase integration
  ///
  /// Flow:
  /// 1. Show payment confirmation dialog
  /// 2. On confirm: Call viewModel.buySingleTicket() (awaits Firebase)
  /// 3. Show success message
  /// 4. Dismiss dialog
  static void handleBuyTicket(BuildContext context) {
    final viewModel = context.read<BookingViewModel>();
    showDialog(
      context: context,
      builder: (dialogContext) => PaymentDialog(
        onConfirm: () async {
          try {
            // Create ticket in Firebase and set as active pass
            await viewModel.buySingleTicket();
            _showTicketPurchaseSuccess(context);
            if (context.mounted) {
              Navigator.of(dialogContext).pop();
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${viewModel.error}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        onCancel: () {},
      ),
    );
  }
}
