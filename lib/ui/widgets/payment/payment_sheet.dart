import 'package:flutter/material.dart';

import '../../../utils/app_theme.dart';
import '../app_button.dart';
import 'payment_success_view.dart';

enum _PaymentStage { form, loading, success }

class PaymentSheet extends StatefulWidget {
  final String title;
  final String amountLabel;
  final String confirmButtonLabel;
  final String successTitle;
  final String successMessage;
  final Future<bool> Function() onConfirmPayment;
  final VoidCallback? onSuccess;

  const PaymentSheet({
    super.key,
    required this.title,
    required this.amountLabel,
    required this.onConfirmPayment,
    this.confirmButtonLabel = 'Confirm Payment',
    this.successTitle = 'Payment Successful',
    this.successMessage = 'Pass Activated',
    this.onSuccess,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String amountLabel,
    required Future<bool> Function() onConfirmPayment,
    String confirmButtonLabel = 'Confirm Payment',
    String successTitle = 'Payment Successful',
    String successMessage = 'Pass Activated',
    VoidCallback? onSuccess,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PaymentSheet(
        title: title,
        amountLabel: amountLabel,
        onConfirmPayment: onConfirmPayment,
        confirmButtonLabel: confirmButtonLabel,
        successTitle: successTitle,
        successMessage: successMessage,
        onSuccess: onSuccess,
      ),
    );
  }

  @override
  State<PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends State<PaymentSheet> {
  final TextEditingController _cardController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  _PaymentStage _stage = _PaymentStage.form;
  String? _validationError;

  @override
  void dispose() {
    _cardController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _confirmPayment() async {
    final error = _validate();
    if (error != null) {
      setState(() => _validationError = error);
      return;
    }

    setState(() {
      _validationError = null;
      _stage = _PaymentStage.loading;
    });

    final success = await widget.onConfirmPayment();

    if (!mounted) {
      return;
    }

    if (!success) {
      setState(() {
        _stage = _PaymentStage.form;
        _validationError = 'Payment failed. Please try again.';
      });
      return;
    }

    setState(() => _stage = _PaymentStage.success);
    widget.onSuccess?.call();

    await Future.delayed(const Duration(milliseconds: 850));

    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  String? _validate() {
    final card = _cardController.text.replaceAll(RegExp(r'\D'), '');
    if (card.length < 12) {
      return 'Please enter a valid card number.';
    }

    if (!RegExp(r'^(0[1-9]|1[0-2])\/(\d{2})$').hasMatch(_expiryController.text)) {
      return 'Expiry date must be MM/YY.';
    }

    final cvv = _cvvController.text.replaceAll(RegExp(r'\D'), '');
    if (cvv.length < 3) {
      return 'Please enter a valid CVV.';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            child: _stage == _PaymentStage.success
                ? SizedBox(
                    key: const ValueKey('success'),
                    height: 260,
                    child: PaymentSuccessView(
                      title: widget.successTitle,
                      message: widget.successMessage,
                    ),
                  )
                : Column(
                    key: ValueKey('form-$_stage'),
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 48,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.gray300,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _InputRow(
                        cardController: _cardController,
                        expiryController: _expiryController,
                        cvvController: _cvvController,
                        onChanged: () {
                          if (!mounted) return;
                          setState(() {
                            if (_validationError != null) {
                              _validationError = null;
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              color: AppColors.gray600,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            widget.amountLabel,
                            style: const TextStyle(
                              color: AppColors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      if (_validationError != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          _validationError!,
                          style: const TextStyle(
                            color: AppColors.error,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      const SizedBox(height: 14),
                      AppButton(
                        label: _stage == _PaymentStage.loading
                            ? 'Processing...'
                            : widget.confirmButtonLabel,
                        onPressed: _confirmPayment,
                        isLoading: _stage == _PaymentStage.loading,
                        enabled: _stage != _PaymentStage.loading,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _InputRow extends StatelessWidget {
  final TextEditingController cardController;
  final TextEditingController expiryController;
  final TextEditingController cvvController;
  final VoidCallback onChanged;

  const _InputRow({
    required this.cardController,
    required this.expiryController,
    required this.cvvController,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: cardController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Card Number',
            hintText: '4242 4242 4242 4242',
          ),
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: expiryController,
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  labelText: 'Expiry',
                  hintText: 'MM/YY',
                ),
                onChanged: (_) => onChanged(),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: cvvController,
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  hintText: '***',
                ),
                onChanged: (_) => onChanged(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
