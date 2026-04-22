import 'package:flutter/material.dart';
import '../../../../model/bike.dart';
import '../../../../model/station.dart';
import '../../../../utils/animations_util.dart';
import '../../../../utils/app_theme.dart';

/// Reusable widget for available bikes section with smooth entrance animations.
///
/// [onRentBike] now receives the tapped [Bike] and its [slotIndex] so the
/// caller can forward the exact bike to RentingScreen.
class AvailableBikesSection extends StatefulWidget {
  final Station station;

  /// Called with (bike, slotIndex) when user taps Rent on a specific card.
  final void Function(Bike bike, int slotIndex)? onRentBike;

  const AvailableBikesSection({
    super.key,
    required this.station,
    this.onRentBike,
  });

  @override
  State<AvailableBikesSection> createState() => _AvailableBikesSectionState();
}

class _AvailableBikesSectionState extends State<AvailableBikesSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AnimationUtils.normal,
      vsync: this,
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
    final bikes = widget.station.availableBikeEntries;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.update, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              const Text(
                'Real-time Slot Status',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (bikes.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: bikes.length,
              itemBuilder: (context, index) {
                final entry = bikes[index];
                final slotIndex = entry.key;
                final bike = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _AnimatedBikeSlotCard(
                    slotNumber: slotIndex + 1,
                    bike: bike,
                    animationDelay: index * 50,
                    // Wrap with the specific bike + slot so the parent knows
                    // exactly which one was tapped
                    onRent: widget.onRentBike != null
                        ? () => widget.onRentBike!(bike, slotIndex)
                        : null,
                  ),
                );
              },
            )
          else
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'No bikes available at this station',
                  style: TextStyle(
                    color: AppColors.gray500,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.gray50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.gray100),
            ),
            child: Row(
              children: [
                const Icon(Icons.schedule, color: AppColors.gray600, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Rent for up to 15 minutes',
                    style: TextStyle(
                      color: AppColors.gray700,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Internal animated card ────────────────────────────────────────────────────

class _AnimatedBikeSlotCard extends StatefulWidget {
  final int slotNumber;
  final Bike bike;
  final VoidCallback? onRent;
  final int animationDelay;

  const _AnimatedBikeSlotCard({
    required this.slotNumber,
    required this.bike,
    this.onRent,
    this.animationDelay = 0,
  });

  @override
  State<_AnimatedBikeSlotCard> createState() => _AnimatedBikeSlotCardState();
}

class _AnimatedBikeSlotCardState extends State<_AnimatedBikeSlotCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AnimationUtils.normal,
      vsync: this,
    );
    _fadeAnimation = AnimationUtils.createFadeAnimation(_controller);
    _slideAnimation = AnimationUtils.createSlideAnimation(_controller);

    Future.delayed(Duration(milliseconds: widget.animationDelay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isElectric = widget.bike.batteryLevel != null;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.gray50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.gray200, width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isElectric ? Icons.electric_bike : Icons.pedal_bike,
                  color: isElectric ? AppColors.success : AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isElectric
                          ? 'Electric Bike | Battery: ${widget.bike.batteryLevel}%'
                          : 'Mechanical Bike',
                      style: TextStyle(
                        color: isElectric ? AppColors.success : AppColors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.1,
                      ),
                    ),
                    Text(
                      'Slot #${widget.slotNumber}',
                      style: const TextStyle(
                        color: AppColors.gray500,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.onRent != null)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onRent,
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Rent',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
