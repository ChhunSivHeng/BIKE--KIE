import 'package:flutter/material.dart';
import '../../../utils/app_theme.dart';

class AppSearchBar extends StatefulWidget {
  const AppSearchBar({
    super.key,
    this.hintText = 'Where are you going?',
    this.onTap,
    this.onFilterTap,
  });

  final String hintText;
  final VoidCallback? onTap;
  final VoidCallback? onFilterTap;

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
    _shadowAnimation = Tween<double>(begin: 0, end: 1.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _hoverController.forward(),
      onExit: (_) => _hoverController.reverse(),
      child: GestureDetector(
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedBuilder(
            animation: _shadowAnimation,
            builder: (context, child) {
              return Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: Color.lerp(
                      AppColors.gray50,
                      AppColors.primary,
                      _shadowAnimation.value * 0.3,
                    )!,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(
                        0.15 * _shadowAnimation.value,
                      ),
                      blurRadius: 16 + (8 * _shadowAnimation.value),
                      offset: Offset(0, 6 + (2 * _shadowAnimation.value)),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(
                        0.08 * (1 - _shadowAnimation.value),
                      ),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: AppColors.primary, size: 20),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        widget.hintText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.gray500,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    Container(
                      height: 24,
                      width: 1.5,
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.gray100.withOpacity(0),
                            AppColors.gray300,
                            AppColors.gray100.withOpacity(0),
                          ],
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: widget.onFilterTap,
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.tune,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
