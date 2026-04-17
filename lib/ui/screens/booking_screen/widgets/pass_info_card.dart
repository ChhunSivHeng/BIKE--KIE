import 'package:flutter/material.dart';
import '../../../../utils/app_theme.dart';
import 'booking_theme.dart';
import 'pass_detail_item.dart';

/// Card displaying active pass information
class PassInfoCard extends StatelessWidget {
  final String passTypeName;
  final String validUntil;

  const PassInfoCard({
    super.key,
    required this.passTypeName,
    required this.validUntil,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(BookingTheme.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(BookingTheme.radiusLarge),
        border: Border.all(color: AppColors.primary),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(passTypeName, style: BookingTheme.passTypeName),
          const SizedBox(height: BookingTheme.spacingMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PassDetailItem(label: 'Valid Until', value: validUntil),
              PassDetailItem(label: 'Booking Fee', value: 'INCLUDED'),
            ],
          ),
        ],
      ),
    );
  }
}
