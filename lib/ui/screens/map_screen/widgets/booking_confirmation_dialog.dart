import 'package:flutter/material.dart';
import '../../../../utils/animations_util.dart';

/// Animated booking confirmation dialog with smooth scale and fade effects
class BookingConfirmationDialog extends StatefulWidget {
  final String stationName;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const BookingConfirmationDialog({
    super.key,
    required this.stationName,
    required this.onConfirm,
    this.onCancel,
  });

  @override
  State<BookingConfirmationDialog> createState() =>
      _BookingConfirmationDialogState();

  /// Static method to show the dialog
  static void show(
    BuildContext context, {
    required String stationName,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    showDialog(
      context: context,
      builder: (context) => BookingConfirmationDialog(
        stationName: stationName,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }
}

class _BookingConfirmationDialogState extends State<BookingConfirmationDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AnimationUtils.normal,
      vsync: this,
    );
    _scaleAnimation = AnimationUtils.createScaleAnimation(
      _controller,
      curve: Curves.elasticOut,
    );
    _fadeAnimation = AnimationUtils.createFadeAnimation(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: AlertDialog(
          title: const Text('Confirm Booking'),
          content: Text(
            'Book a bike from ${widget.stationName}?\n\nYou can reserve it for up to 15 minutes.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onCancel?.call();
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onConfirm();
              },
              child: const Text('Book Now'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Utility to show success snackbar with smooth animation
void showBookingSuccessSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text('✓ Bike booked successfully!'),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.all(16),
    ),
  );
}
