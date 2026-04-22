import 'package:flutter/material.dart';

import '../../../../../model/pass.dart';
import '../../../../utils/app_theme.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/navigation/app_header.dart';
import '../../../widgets/payment/payment_sheet.dart';
import '../view_model/pass_model.dart';
import 'pass_card.dart';
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

          final selected = vm.selectedPass;
          final activePass = vm.passes.cast<Pass?>().firstWhere(
            (p) => p != null && p.isActive,
            orElse: () => null,
          );

          return Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.only(top: AppHeader.height + 12),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                    children: [

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Pass Selection',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Choose the membership that fits your rhythm.',
                            style: TextStyle(
                              color: AppColors.gray500,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      if (vm.hasCurrentPass)
                        _buildCurrentPassSection(vm, context),

                      if (vm.hasCurrentPass) const SizedBox(height: 24),

                      if (!vm.hasCurrentPass)
                        PassStatusCard(
                          activePass: activePass,
                          selectedPass: selected,
                          isProcessingPayment: vm.isProcessingPayment,
                        ),

                      if (!vm.hasCurrentPass) const SizedBox(height: 12),
                      if (!vm.hasCurrentPass)
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 12),
                          child: Text(
                            'AVAILABLE PASSES',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: AppColors.gray600,
                                  letterSpacing: 0.5,
                                ),
                          ),
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

                      if (selected != null && !selected.isActive) ...[
                        const SizedBox(height: 16),
                        AppButton(
                          label: vm.isProcessingPayment
                              ? 'Processing...'
                              : vm.hasCurrentPass
                                  ? vm.isUpgrade
                                      ? 'Upgrade Pass'
                                      : vm.isExtension
                                          ? 'Extend Pass'
                                          : 'Switch Pass'
                                  : 'Buy Pass',
                          onPressed: () async {
                            final selectedPass = vm.selectedPass;
                            if (selectedPass == null || !context.mounted) {
                              return;
                            }

                            final isUpdate = vm.hasCurrentPass;
                            final title = isUpdate ? 'Confirm Pass Update' : 'Confirm Pass Purchase';
                            final successMsg = isUpdate ? 'Pass Updated' : 'Pass Activated';

                            final paid = await PaymentSheet.show(
                              context,
                              title: title,
                              amountLabel:
                                  '\$${selectedPass.price.toStringAsFixed(2)}',
                              confirmButtonLabel: isUpdate ? 'Pay & Update' : 'Pay & Activate',
                              successMessage: successMsg,
                              onConfirmPayment: isUpdate ? vm.updatePass : vm.processPayment,
                            );

                            if (paid == true && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isUpdate 
                                      ? '✓ Pass updated to ${selectedPass.type.name.toUpperCase()}!'
                                      : '✓ ${selectedPass.type.name.toUpperCase()} pass purchased!',
                                  ),
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            } else if (paid != true && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(vm.error ?? 'Payment failed'),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          isLoading: vm.isProcessingPayment,
                          enabled: !vm.isProcessingPayment,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const Positioned(left: 0, right: 0, top: 0, child: AppHeader()),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCurrentPassSection(PassViewModel vm, BuildContext context) {
    final currentPass = vm.currentPass;
    if (currentPass == null) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'YOUR CURRENT PASS',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.gray600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.08),
                AppColors.primary.withOpacity(0.02),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Active Pass',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentPass.type.name.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(height: 1, color: AppColors.gray200),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDetailItem(
                    'Valid Until',
                    currentPass.endDate.toString().split(' ')[0],
                    context,
                  ),
                  _buildDetailItem('Price', '\$${currentPass.price}', context),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.gray600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}
