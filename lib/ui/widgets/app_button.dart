import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

/// AppButton - Reusable button component with loading and customization support
/// Minimal implementation with essential features only
///
/// Usage:
/// ```dart
/// // Basic usage
/// AppButton(label: 'Login', onPressed: () => handleLogin())
///
/// // With loading state
/// AppButton(label: 'Login', onPressed: () => handleLogin(), isLoading: isLoading)
///
/// // Outlined variant
/// AppButton(label: 'Cancel', onPressed: () => cancel(), outlined: true)
///
/// // Custom colors
/// AppButton(
///   label: 'Subscribe',
///   onPressed: () => subscribe(),
///   backgroundColor: AppColors.success,
/// )
/// ```
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final IconData? icon;
  final bool outlined;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double height;
  final double borderRadius;
  final bool fullWidth;
  final EdgeInsetsGeometry padding;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.icon,
    this.outlined = false,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 52,
    this.borderRadius = 12,
    this.fullWidth = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = isLoading || !enabled || onPressed == null;

    final buttonChild = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 18,
                  color: outlined
                      ? (foregroundColor ?? AppColors.primary)
                      : (foregroundColor ?? Colors.white),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: outlined
                      ? (foregroundColor ?? AppColors.primary)
                      : (foregroundColor ?? Colors.white),
                ),
              ),
            ],
          );

    final style = outlined
        ? OutlinedButton.styleFrom(
            foregroundColor: foregroundColor ?? AppColors.primary,
            side: BorderSide(
              color: isDisabled
                  ? AppColors.gray300
                  : (foregroundColor ?? AppColors.primary),
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: padding,
          )
        : ElevatedButton.styleFrom(
            backgroundColor: isDisabled
                ? AppColors.gray300
                : (backgroundColor ?? AppColors.primary),
            foregroundColor: foregroundColor ?? Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: padding,
          );

    final buttonWidget = outlined
        ? OutlinedButton(
            onPressed: isDisabled ? null : onPressed,
            style: style,
            child: buttonChild,
          )
        : ElevatedButton(
            onPressed: isDisabled ? null : onPressed,
            style: style,
            child: buttonChild,
          );

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height,
      child: buttonWidget,
    );
  }
}
