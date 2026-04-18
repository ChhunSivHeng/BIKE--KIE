import 'package:flutter/material.dart';
import '../../../../../utils/app_theme.dart';

class StationMarker extends StatefulWidget {
  const StationMarker({super.key, required this.availableBikes, this.onTap});

  final int availableBikes;
  final VoidCallback? onTap;

  @override
  State<StationMarker> createState() => _StationMarkerState();
}

class _StationMarkerState extends State<StationMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasBikes = widget.availableBikes > 0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        _animationController.reverse();
      },
      onExit: (_) {
        _animationController.forward();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: 48,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: hasBikes
                  ? AppColors.primaryGradient
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.gray300, AppColors.gray100],
                    ),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: AppColors.black),
              boxShadow: hasBikes ? AppShadows.redGlow : AppShadows.md,
            ),
            child: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.pedal_bike,
                        color: hasBikes ? Colors.white : AppColors.gray400,
                        size: 18,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.availableBikes.toString(),
                        style: TextStyle(
                          color: hasBikes ? Colors.white : AppColors.gray500,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          height: 1,
                        ),
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
