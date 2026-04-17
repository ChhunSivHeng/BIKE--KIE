import 'package:flutter/material.dart';
import '../../../utils/app_theme.dart';

enum BottomNavTab { map, passes, profile }

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.activeTab,
    this.onTabSelected,
  });

  final BottomNavTab activeTab;
  final ValueChanged<BottomNavTab>? onTabSelected;

  static const double height = 76;

  @override
Widget build(BuildContext context) {
  return Container(
    height: height,
    decoration: const BoxDecoration(
      color: AppColors.white,
      border: Border(top: BorderSide(color: Color(0x11000000))),
    ),
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _NavItem(
          label: 'PASSES',
          icon: Icons.confirmation_number_outlined,
          isActive: activeTab == BottomNavTab.passes,
          onTap: () => onTabSelected?.call(BottomNavTab.passes),
        ),
        _NavItem(
          label: 'MAP',
          icon: Icons.map_outlined,
          isActive: activeTab == BottomNavTab.map,
          onTap: () => onTabSelected?.call(BottomNavTab.map),
        ),
        _NavItem(
          label: 'PROFILE',
          icon: Icons.person_outline,
          isActive: activeTab == BottomNavTab.profile,
          onTap: () => onTabSelected?.call(BottomNavTab.profile),
        ),
      ],
    ),
  );
}
}
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const activeColor = AppColors.primary;
    const inactiveColor = AppColors.gray400;
    final color = isActive ? activeColor : inactiveColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: 6.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                letterSpacing: 0.4,
              ),
            ), 
          ],
        ),
      ),
    );
  }
}
