import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class AppInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hintText;
  final String? error;
  final bool enabled;
  final IconData? prefixIcon;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmit;

  const AppInputField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.error,
    this.enabled = true,
    this.prefixIcon,
    this.onChanged,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = error != null && error!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          onChanged: onChanged,
          onFieldSubmitted: onSubmit != null ? (_) => onSubmit!() : null,
          textInputAction: TextInputAction.go,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: enabled ? AppColors.gray50 : AppColors.gray100,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 20, color: AppColors.gray500)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError
                    ? Colors.red.withOpacity(0.3)
                    : AppColors.gray200,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError ? Colors.red : AppColors.primary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 8),
          Text(
            error!,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
