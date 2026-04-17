import 'package:flutter/material.dart';
import '../../../../model/station.dart';
import '../../../../utils/animations_util.dart';
import '../../../../utils/app_theme.dart';

/// Reusable widget for nearby stations section with smooth animations
class NearbyStationsSection extends StatefulWidget {
  final Station currentStation;
  final List<Station> nearbyStations;
  final Function(Station) onSelectStation;

  const NearbyStationsSection({
    super.key,
    required this.currentStation,
    required this.nearbyStations,
    required this.onSelectStation,
  });

  @override
  State<NearbyStationsSection> createState() => _NearbyStationsSectionState();
}

class _NearbyStationsSectionState extends State<NearbyStationsSection>
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
    if (widget.nearbyStations.isEmpty) {
      return const SizedBox.shrink();
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Other Nearby Stations (${widget.nearbyStations.length})',
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.nearbyStations.length,
            itemBuilder: (context, index) {
              final station = widget.nearbyStations[index];
              final isActive = station.id == widget.currentStation.id;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _AnimatedStationSwitchCard(
                  station: station,
                  isActive: isActive,
                  onTap: () => widget.onSelectStation(station),
                  animationDelay: index * 50,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Animated station switch card component
class _AnimatedStationSwitchCard extends StatefulWidget {
  final Station station;
  final bool isActive;
  final VoidCallback onTap;
  final int animationDelay;

  const _AnimatedStationSwitchCard({
    required this.station,
    required this.isActive,
    required this.onTap,
    this.animationDelay = 0,
  });

  @override
  State<_AnimatedStationSwitchCard> createState() =>
      _AnimatedStationSwitchCardState();
}

class _AnimatedStationSwitchCardState extends State<_AnimatedStationSwitchCard>
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
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.isActive
                    ? AppColors.primary.withOpacity(0.1)
                    : AppColors.gray50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.isActive
                      ? AppColors.primary
                      : AppColors.gray100,
                  width: widget.isActive ? 2 : 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.station.name,
                              style: TextStyle(
                                color: widget.isActive
                                    ? AppColors.primary
                                    : AppColors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.2,
                              ),
                            ),
                            if (widget.isActive)
                              const Padding(
                                padding: EdgeInsets.only(left: 6),
                                child: Icon(
                                  Icons.check_circle,
                                  color: AppColors.primary,
                                  size: 16,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.pedal_bike,
                              color: AppColors.gray500,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.station.bikeAmounts} bikes available',
                              style: const TextStyle(
                                color: AppColors.gray600,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: widget.isActive
                        ? AppColors.primary
                        : AppColors.gray400,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
