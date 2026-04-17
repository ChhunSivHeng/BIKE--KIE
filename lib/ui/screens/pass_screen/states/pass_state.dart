import '../../../../model/pass.dart';

enum PassStatus { loading, success, error }

class PassState {
  final PassStatus status;
  final List<Pass> passes;
  final Pass? selectedPass;
  final String? error;

  const PassState._({
    required this.status,
    required this.passes,
    required this.selectedPass,
    required this.error,
  });

  factory PassState.loading() => const PassState._(
    status: PassStatus.loading,
    passes: <Pass>[],
    selectedPass: null,
    error: null,
  );

  factory PassState.success({required List<Pass> passes, Pass? selectedPass}) =>
      PassState._(
        status: PassStatus.success,
        passes: List<Pass>.unmodifiable(passes),
        selectedPass: selectedPass,
        error: null,
      );

  factory PassState.error(String message) => PassState._(
    status: PassStatus.error,
    passes: const <Pass>[],
    selectedPass: null,
    error: message,
  );
}
