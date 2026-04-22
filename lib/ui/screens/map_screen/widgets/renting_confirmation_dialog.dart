import 'package:flutter/material.dart';
import '../../../../utils/animations_util.dart';

class RentingConfirmationDialog extends StatefulWidget {
  final String stationName;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const RentingConfirmationDialog({
    super.key,
    required this.stationName,
    required this.onConfirm,
    this.onCancel,
  });

  @override
  State<RentingConfirmationDialog> createState() =>
      _RentingConfirmationDialogState();

  static void show(
    BuildContext context, {
    required String stationName,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    showDialog(
      context: context,
      builder: (context) => RentingConfirmationDialog(
        stationName: stationName,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }
}

class _RentingConfirmationDialogState extends State<RentingConfirmationDialog>
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
          title: const Text('Confirm Renting'),
          content: Text(
            'Rent a bike from ${widget.stationName}?',
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
              child: const Text('Rent Now'),
            ),
          ],
        ),
      ),
    );
  }
}
void showRentingSuccessSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text('✓ Bike rented successfully!'),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.all(16),
    ),
  );
}
