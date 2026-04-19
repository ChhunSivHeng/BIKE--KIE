import 'package:flutter/foundation.dart';

import '../../../../data/repositories/passRepository/pass_repository.dart';
import '../../../../model/pass.dart';

/// ViewModel for Pass Screen
///
/// Manages:
/// - Loading all available passes from PassRepository (Firebase)
/// - Pass selection
/// - Pass purchase simulation
///
/// Requires PassRepository to be injected via dependency injection.
class PassViewModel extends ChangeNotifier {
  final PassRepository _repo;

  bool isLoading = false;
  bool isProcessingPayment = false;
  List<Pass> passes = [];
  Pass? selectedPass;
  String? error;

  PassViewModel({required PassRepository passRepository})
    : _repo = passRepository;

  void _notify() {
    notifyListeners();
  }

  Future<void> loadPasses() async {
    isLoading = true;
    error = null;
    _notify();

    try {
      final rawPasses = await _repo.getPasses();
      passes = rawPasses;
      selectedPass = null;
    } catch (_) {
      error = 'Failed to load pass';
    }

    isLoading = false;
    _notify();
  }

  void selectPass(Pass selected) {
    if (isLoading || error != null) {
      return;
    }

    selectedPass = selected;
    _notify();
  }

  Future<void> processPayment() async {
    if (isLoading || selectedPass == null || isProcessingPayment) {
      return;
    }

    final selected = selectedPass!;
    isProcessingPayment = true;
    _notify();

    await Future.delayed(const Duration(seconds: 2));

    passes = passes
        .map(
          (p) => Pass(
            id: p.id,
            type: p.type,
            price: p.price,
            startDate: p.startDate,
            endDate: p.endDate,
            isActive: p.id == selected.id,
          ),
        )
        .toList(growable: false);

    selectedPass = passes.firstWhere((p) => p.isActive);
    isProcessingPayment = false;
    _notify();
  }
}
