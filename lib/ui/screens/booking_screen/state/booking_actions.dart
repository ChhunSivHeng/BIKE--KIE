import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../model/user.dart';
import '../view_model/booking_model.dart';
import '../widgets/payment_dialog.dart';
import '../../success_screen/success_screen.dart';

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
  ///
  /// After user purchases a pass, captures the returned User data
  /// and updates the BookingViewModel to show the confirm booking screen
  static void handleBrowsePasses(
    BuildContext context,
    BookingViewModel viewModel,
    VoidCallback onReturn,
  ) {
    Navigator.pushNamed(context, '/passes').then((result) {
      // If user purchased a pass, result will be the updated User
      if (result is User && context.mounted) {
        viewModel.updateUserWithPass(result);
      }
      onReturn();
    });
  }

  /// Show payment dialog for single ticket purchase with Firebase integration
  ///
  /// Flow:
  /// 1. Show payment dialog with confirmation
  /// 2. User clicks Confirm → ProcessPayment shows steps
  /// 3. onConfirm callback: Creates ticket in Firebase via viewModel.buySingleTicket()
  /// 4. Dialog closes automatically on success
  /// 5. BookingViewModel state is automatically updated with new ticket pass
  static void handleBuyTicket(BuildContext context, VoidCallback onSuccess) {
    final viewModel = context.read<BookingViewModel>();
    showDialog(
      context: context,
      builder: (dialogContext) => PaymentDialog(
        onConfirm: () async {
          try {
            // Create ticket in Firebase and set as active pass
            await viewModel.buySingleTicket();
            onSuccess();
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${viewModel.error}'),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
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
