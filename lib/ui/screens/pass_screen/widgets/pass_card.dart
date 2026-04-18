import 'package:flutter/material.dart';

import '../../../../model/pass.dart';
import '../../../../utils/app_theme.dart';

class PassCard extends StatelessWidget {

  final Pass pass;
  final bool isSelected;
  final bool isCurrent;
  final VoidCallback onTap;

  const PassCard({
    super.key,
    required this.pass,
    required this.isSelected,
    required this.isCurrent,
    required this.onTap,
  });

  String get _name {
    switch (pass.type) {
      case PassType.day:
        return 'Day Pass';
      case PassType.monthly:
        return 'Monthly Pass';
      case PassType.annual:
        return 'Annual Pass';
    }
  }

  String get _subtitle {
    switch (pass.type) {
      case PassType.day:
        return '24 hours of unlimited rides';
      case PassType.monthly:
        return 'The commuter\'s choice';
      case PassType.annual:
        return 'The city is your backyard';
    }
  }

  List<String> get _benefits {
    switch (pass.type) {
      case PassType.day:
        return const [
          'First 30m of every ride free',
          'Single city access',
        ];
      case PassType.monthly:
        return const [
          'First 60m of every ride free',
          'Unlimited unlocks',
          'Member-only zones',
        ];
      case PassType.annual:
        return const [
          'All Monthly benefits',
          'Guest ride credits (2/mo)',
          'Priority support access',
        ];
    }
  }

  int get _durationDays => pass.endDate.difference(pass.startDate).inDays;

  String get _durationLabel {
    if (_durationDays <= 1) {
      return '24 hours';
    }
    if (_durationDays < 31) {
      return '$_durationDays days';
    }
    if (_durationDays < 365) {
      return '${(_durationDays / 30).round()} month';
    }
    return '${(_durationDays / 365).round()} year';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.gray200,
          width: isSelected ? 1.5 : 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _name,
                            style: const TextStyle(
                              color: AppColors.black,
                              fontSize: 28 / 2,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _subtitle,
                            style: const TextStyle(
                              color: AppColors.gray600,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${pass.price.toStringAsFixed(pass.price.truncateToDouble() == pass.price ? 0 : 2)}',
                          style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 32 / 2,
                            fontWeight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _durationLabel.toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.gray500,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                for (final benefit in _benefits)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check,
                          size: 14,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            benefit,
                            style: const TextStyle(
                              color: AppColors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
