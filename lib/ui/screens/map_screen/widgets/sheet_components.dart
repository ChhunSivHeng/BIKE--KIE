import 'package:flutter/material.dart';
import '../../../../utils/app_theme.dart';

/// Reusable drag handle widget
class DragHandle extends StatelessWidget {
  const DragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.gray200,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

/// Reusable sheet container
class SheetContainer extends StatelessWidget {
  final Widget child;

  const SheetContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(color: Color(0x1A000000), blurRadius: 16, spreadRadius: 2),
        ],
      ),
      child: child,
    );
  }
}
