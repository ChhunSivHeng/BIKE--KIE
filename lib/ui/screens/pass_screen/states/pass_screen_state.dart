import 'package:flutter/foundation.dart';

import '../../../../data/repositories/passRepository/pass_repository.dart';
import '../../../../model/pass.dart';

class PassScreenState extends ChangeNotifier {
  final PassRepository _repo;

  PassScreenState({required PassRepository repo}) : _repo = repo;

  bool isLoading = false;
  bool isProcessingPayment = false;
  List<Pass> passes = [];
  Pass? selectedPass;
  String? error;

  Future<void> loadPasses() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final rawPasses = await _repo.getPasses();
      passes = rawPasses;
      selectedPass = null;
    } catch (_) {
      error = 'Failed to load pass';
    }

    isLoading = false;
    notifyListeners();
  }

  void selectPass(Pass selected) {
    if (isLoading || error != null) {
      return;
    }

    selectedPass = selected;
    notifyListeners();
  }

  Future<void> processPayment() async {
    if (isLoading || selectedPass == null || isProcessingPayment) {
      return;
    }

    final selected = selectedPass!;
    isProcessingPayment = true;
    notifyListeners();

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
    notifyListeners();
  }
}
