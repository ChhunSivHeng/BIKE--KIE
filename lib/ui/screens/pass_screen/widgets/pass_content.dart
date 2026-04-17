import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../model/pass.dart';
import '../../../../utils/app_theme.dart';
import '../../../widgets/navigation/app_header.dart';
import '../../map_screen/map_screen.dart';
import '../states/pass_state.dart';
import '../view_model/pass_model.dart';
import 'pass_card.dart';

class PassContent extends StatelessWidget {
  const PassContent({super.key});

  String _activePassTitle(Pass pass) {
    switch (pass.type) {
      case PassType.day:
        return 'Daily Explorer';
      case PassType.monthly:
        return 'Monthly Explorer';
      case PassType.annual:
        return 'Annual Explorer';
    }
  }

  String _formatDate(DateTime date) {
    const months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: Consumer<PassViewModel>(
        builder: (context, vm, _) {
          final state = vm.state;

          if (state.status == PassStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == PassStatus.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.error ?? 'Something went wrong',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.gray700,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: vm.loadPasses,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final selected = state.selectedPass;
          final activePass = state.passes.cast<Pass?>().firstWhere(
                (p) => p != null && p.isActive,
                orElse: () => null,
              );

          return Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: AppHeader.height + 12,
                  ),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                    children: [
                      const Text(
                        'Pass Selection',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 36 / 2,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Choose the membership that fits your rhythm.',
                        style: TextStyle(
                          color: AppColors.gray500,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (activePass != null || selected != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F7),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.gray200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activePass != null
                                    ? 'CURRENT ACTIVE PASS'
                                    : 'SELECTED PLAN',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.6,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _activePassTitle(activePass ?? selected!),
                                style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 23 / 2,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Expires on ${_formatDate((activePass ?? selected!).endDate)}',
                                style: const TextStyle(
                                  color: AppColors.gray600,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (state.isProcessingPayment) ...[
                                const SizedBox(height: 10),
                                Row(
                                  children: const [
                                    SizedBox(
                                      height: 14,
                                      width: 14,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Processing payment...',
                                      style: TextStyle(
                                        color: AppColors.gray600,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        )
                      else
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F7),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.gray300),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'INVALID PASS',
                                style: TextStyle(
                                  color: AppColors.gray500,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.6,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'No Subscription',
                                style: TextStyle(
                                  color: AppColors.gray600,
                                  fontSize: 23 / 2,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Subscribe to start riding',
                                style: TextStyle(
                                  color: AppColors.gray500,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ...state.passes.map(
                        (pass) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: PassCard(
                            pass: pass,
                            isSelected: state.selectedPass?.id == pass.id,
                            isCurrent: pass.isActive,
                            onTap: state.isProcessingPayment
                                ? () {}
                                : () => vm.selectPass(pass),
                          ),
                        ),
                      ),
                      if (selected != null) ...[
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: state.isProcessingPayment
                              ? null
                              : () async {
                                  await vm.processPayment();
                                },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            state.isProcessingPayment
                                ? 'Processing...'
                                : 'Process Payment',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: AppHeader(),
              ),
            ],
          );
        },
      ),
    );
  }
}
