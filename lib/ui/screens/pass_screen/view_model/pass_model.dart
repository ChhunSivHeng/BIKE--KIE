import 'package:flutter/foundation.dart';

import '../../../../data/repositories/passRepository/pass_repository.dart';
import '../../../../data/repositories/passRepository/pass_repositoryMock.dart';
import '../../../../model/pass.dart';
import '../states/pass_screen_state.dart';

class PassViewModel extends ChangeNotifier {
  final PassScreenState passState;

  PassViewModel({PassRepository? repo, PassScreenState? state})
      : passState = state ?? PassScreenState(repo: repo ?? PassRepositoryMock()) {
    passState.addListener(onPassStateChanged);
  }

  bool get isLoading => passState.isLoading;
  bool get isProcessingPayment => passState.isProcessingPayment;
  List<Pass> get passes => passState.passes;
  Pass? get selectedPass => passState.selectedPass;
  String? get error => passState.error;

  void onPassStateChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    passState.removeListener(onPassStateChanged);
    super.dispose();
  }

  Future<void> loadPasses() async {
    await passState.loadPasses();
  }

  void selectPass(Pass selected) {
    passState.selectPass(selected);
  }

  Future<void> processPayment() async {
    await passState.processPayment();
  }
}
