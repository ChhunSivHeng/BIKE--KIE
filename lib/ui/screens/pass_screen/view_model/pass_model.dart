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
      final selected = rawPasses.where((p) => p.isActive).cast<Pass?>().firstWhere(
        (p) => p != null,
        orElse: () => null,
      );
      _state = PassState.success(passes: rawPasses, selectedPass: selected);
      notifyListeners();
    } catch (_) {
      _state = PassState.error('Failed to load passes.');
      notifyListeners();
    }
  }

  void selectPass(Pass selected) {
    if (_state.status != PassStatus.success) {
      return;
    }

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
    _state = PassState.success(passes: updated, selectedPass: active);
    notifyListeners();
  }
}
