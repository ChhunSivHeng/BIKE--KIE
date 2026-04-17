import '../../../../model/pass.dart';

enum PassStatus { loading, success, error }

class PassState {
  final PassStatus status;
  final List<Pass> passes;
  final Pass? selectedPass;
  final bool isProcessingPayment;
  final String? error;

  const PassState._({
    required this.status,
    required this.passes,
    required this.selectedPass,
    required this.isProcessingPayment,
    required this.error,
  });

  factory PassState.loading() => const PassState._(
    status: PassStatus.loading,
    passes: <Pass>[],
    selectedPass: null,
    isProcessingPayment: false,
    error: null,
  );

  factory PassState.success({
    required List<Pass> passes,
    Pass? selectedPass,
    bool isProcessingPayment = false,
  }) =>
      PassState._(
        status: PassStatus.success,
        passes: List<Pass>.unmodifiable(passes),
        selectedPass: selectedPass,
        isProcessingPayment: isProcessingPayment,
        error: null,
      );

  factory PassState.error(String message) => PassState._(
    status: PassStatus.error,
    passes: const <Pass>[],
    selectedPass: null,
    isProcessingPayment: false,
    error: message,
  );
}
