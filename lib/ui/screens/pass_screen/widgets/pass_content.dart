import 'package:flutter/material.dart';

import '../../../../../model/pass.dart';
import '../../../../utils/app_theme.dart';
import '../../../widgets/navigation/app_header.dart';
import '../view_model/pass_model.dart';
import 'pass_card.dart';
import 'pass_error_state.dart';
import 'pass_payment_button.dart';
import 'pass_section_header.dart';
import 'pass_status_card.dart';

class PassContent extends StatelessWidget {
  final PassViewModel viewModel;

  const PassContent({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: AnimatedBuilder(
        animation: viewModel,
        builder: (context, _) {
          final vm = viewModel;

          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.error != null) {
            return PassErrorState(
              message: vm.error ?? 'Something went wrong',
              onRetry: vm.loadPasses,
            );
          }

          final selected = vm.selectedPass;
          final activePass = vm.passes.cast<Pass?>().firstWhere(
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
                      const PassSectionHeader(),
                      const SizedBox(height: 12),
                      PassStatusCard(
                        activePass: activePass,
                        selectedPass: selected,
                        isProcessingPayment: vm.isProcessingPayment,
                      ),
                      ...vm.passes.map(
                        (pass) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: PassCard(
                            pass: pass,
                            isSelected: vm.selectedPass?.id == pass.id,
                            isCurrent: pass.isActive,
                            onTap: vm.isProcessingPayment
                                ? () {}
                                : () => vm.selectPass(pass),
                          ),
                        ),
                      ),
                      if (selected != null) ...[
                        const SizedBox(height: 16),
                        PassPaymentButton(
                          isProcessing: vm.isProcessingPayment,
                          onProcessPayment: vm.processPayment,
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
