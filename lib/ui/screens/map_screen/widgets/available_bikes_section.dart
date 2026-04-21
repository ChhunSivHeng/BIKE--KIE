import 'package:flutter/material.dart';
import '../../../../model/bike.dart';
import '../../../../model/station.dart';
import '../../../../utils/animations_util.dart';
import '../../../../utils/app_theme.dart';

/// Reusable widget for available bikes section with smooth entrance animations
class AvailableBikesSection extends StatefulWidget {
  final Station station;
  final VoidCallback? onRentBike;

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
          // Principle 1: Visibility - Real-time indicator
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
          // Principle 6: Recognition rather than recall - Show only available bikes
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
                    onRent: widget.onRentBike,
                    animationDelay: index * 50,
                    bike: bike,
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
          // Principle 9: Help & Documentation
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
                    'Reserve for up to 15 minutes',
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

/// Animated bike slot card component
class _AnimatedBikeSlotCard extends StatefulWidget {
  final int slotNumber;
  final Bike bike;
  final VoidCallback? onRent;
  final int animationDelay;

  const _AnimatedBikeSlotCard({
    required this.slotNumber,
    this.onRent,
    this.animationDelay = 0,
    required this.bike,
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

    // Stagger animation based on index
    Future.delayed(Duration(milliseconds: widget.animationDelay), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                child: widget.bike.batteryLevel != null
                    ? Icon(
                        Icons.electric_bike,
                        color: AppColors.success,
                        size: 20,
                      )
                    : Icon(
                        Icons.pedal_bike,
                        color: AppColors.primary,
                        size: 20,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.bike.batteryLevel != null
                        ? Text(
                            'Electric Bike | Battery Level: ${widget.bike.batteryLevel}%',
                            style: TextStyle(
                              color: AppColors.success,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.1,
                            ),
                          )
                        : Text(
                            'Mechanical Bike',
                            style: TextStyle(
                              color: AppColors.black,
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
