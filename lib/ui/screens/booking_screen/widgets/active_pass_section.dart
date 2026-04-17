import 'package:flutter/material.dart';
import 'booking_theme.dart';
import 'booking_constants.dart';
import 'pass_info_card.dart';

/// Shows active pass details
class ActivePassSection extends StatelessWidget {
  final String passTypeName;
  final String validUntil;

  const ActivePassSection({
    super.key,
    required this.passTypeName,
    required this.validUntil,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: BookingTheme.paddingLarge,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            BookingConstants.activeSubscription,
            style: BookingTheme.sectionLabel,
          ),
          const SizedBox(height: BookingTheme.spacingMedium),
          PassInfoCard(passTypeName: passTypeName, validUntil: validUntil),
        ],
      ),
    );
  }
}
