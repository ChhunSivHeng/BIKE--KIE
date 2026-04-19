import 'package:flutter/material.dart';
import '../../../utils/app_theme.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool outlined;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderSide? borderSide;
  final double height;
  final double borderRadius;
  final bool fullWidth;
  final EdgeInsetsGeometry padding;
  final Widget? icon;
  final MainAxisSize contentSize;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.outlined = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderSide,
    this.height = 52,
    this.borderRadius = 12,
    this.fullWidth = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.icon,
    this.contentSize = MainAxisSize.max,
  });

  @override
  Widget build(BuildContext context) {
    final buttonChild = icon == null
        ? Text(label)
        : Row(
            mainAxisSize: contentSize,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [icon!, const SizedBox(width: 8), Text(label)],
          );

    final style = outlined
        ? OutlinedButton.styleFrom(
            foregroundColor: foregroundColor ?? AppColors.primary,
            side:
                borderSide ??
                const BorderSide(color: AppColors.primary, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.primary,
            foregroundColor: foregroundColor ?? AppColors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          );

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height,
      child: outlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: style,
              child: buttonChild,
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: style,
              child: buttonChild,
            ),
    );
  }
}
