import 'package:flutter/material.dart';
import '../../../../utils/animations_util.dart';
import '../../../../utils/app_theme.dart';

/// Animated booking action button with smooth pulse and hover effects
class RentingActionButton extends StatefulWidget {
  final bool hasAvailableBikes;
  final VoidCallback onRent;

  const RentingActionButton({
    super.key,
    required this.hasAvailableBikes,
    required this.onRent,
  });

  @override
  State<RentingActionButton> createState() => _RentingActionButtonState();
}

class _RentingActionButtonState extends State<RentingActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AnimationUtils.verySlow,
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = AnimationUtils.createPulseAnimation(
      _controller,
      minScale: 0.98,
      maxScale: 1.02,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: widget.hasAvailableBikes
          ? SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _controller.stop();
                  widget.onRent();
                },
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('BOOK THIS BIKE'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                  shadowColor: AppColors.primary.withOpacity(0.4),
                ),
              ),
            )
          : Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.gray100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.gray200),
              ),
              child: const Center(
                child: Text(
                  'No bikes available at this station',
                  style: TextStyle(
                    color: AppColors.gray600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
    );
  }
}
