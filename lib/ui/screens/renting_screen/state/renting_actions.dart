import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../model/user.dart';
import '../../pass_screen/pass_screen.dart';
import '../view_model/renting_model.dart';
import '../widgets/payment_dialog.dart';
import '../../success_screen/success_screen.dart';

class RentingActions {
  /// Confirm renting with Firebase.
  ///
  /// Shows a loading indicator, then navigates to SuccessScreen.
  /// Any error is shown as a SnackBar — previously there was no try/catch
  /// so a failed network call would crash the app silently.
  static Future<void> handleConfirmRenting(
    BuildContext context,
    RentingViewModel viewModel,
    VoidCallback onSuccess,
  ) async {
    try {
      await viewModel.confirmRenting();
      onSuccess();

      if (!context.mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SuccessScreen()),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Renting failed: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  /// Navigate to passes screen.
  /// If the user purchases a pass, captures the returned User and updates
  /// the ViewModel so the confirm button appears.
  static void handleBrowsePasses(
    BuildContext context,
    RentingViewModel viewModel,
    VoidCallback onReturn,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(appBar: AppBar(), body: PassScreen()),
      ),
    ).then((result) {
      if (result is User && context.mounted) {
        viewModel.updateUserWithPass(result);
      }
      onReturn();
    });
  }

  /// Show payment dialog for single ticket purchase.
  static void handleBuyTicket(BuildContext context, VoidCallback onSuccess) {
    final viewModel = context.read<RentingViewModel>();
    showDialog(
      context: context,
      builder: (dialogContext) => PaymentDialog(
        onConfirm: () async {
          try {
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
