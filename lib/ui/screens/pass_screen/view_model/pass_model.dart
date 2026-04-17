import 'package:flutter/foundation.dart';

import '../../../../data/repositories/passRepository/pass_repository.dart';
import '../../../../data/repositories/passRepository/pass_repositoryMock.dart';
import '../../../../model/pass.dart';
import '../states/pass_state.dart';

class PassViewModel extends ChangeNotifier {
  final PassRepository _repo;

  PassViewModel({PassRepository? repo}) : _repo = repo ?? PassRepositoryMock();

  PassState _state = PassState.loading();
  PassState get state => _state;

  Future<void> loadPasses() async {
    _state = PassState.loading();
    notifyListeners();

    try {
      final rawPasses = await _repo.getPasses();
      _state = PassState.success(
        passes: rawPasses,
        selectedPass: null,
        isProcessingPayment: false,
      );
      notifyListeners();
    } catch (_) {
      _state = PassState.error('Faile load passes');
      notifyListeners();
    }
  }

  void selectPass(Pass selected) {
    if (_state.status != PassStatus.success) {
      return;
    }
    _state = PassState.success(
      passes: _state.passes,
      selectedPass: selected,
      isProcessingPayment: false,
    );
    notifyListeners();
  }

  Future<void> processPayment() async {
    if (_state.status != PassStatus.success ||
        _state.selectedPass == null ||
        _state.isProcessingPayment) {
      return;
    }
    final selected = _state.selectedPass!;
    _state = PassState.success(
      passes: _state.passes,
      selectedPass: selected,
      isProcessingPayment: true,
    );
    notifyListeners();
    await Future.delayed(const Duration(seconds: 3));
    final updated = _state.passes
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
    final active = updated.firstWhere((p) => p.isActive);
    _state = PassState.success(
      passes: updated,
      selectedPass: active,
      isProcessingPayment: false,
    );
    notifyListeners();
  }
}
