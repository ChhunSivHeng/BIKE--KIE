import 'package:flutter/foundation.dart';

import '../../../../data/repositories/passRepository/pass_repository.dart';
import '../../../../data/repositories/userRepository/user_repository.dart';
import '../../../../model/pass.dart';
import '../../../../model/user.dart';
import '../../../../utils/async_value.dart';

class PassesData {
  final User user;
  final List<Pass> passes;
  final Pass? activePass;
  final String? selectedPassId;
  final String? purchasingPassId;

  const PassesData({
    required this.user,
    required this.passes,
    required this.activePass,
    this.selectedPassId,
    this.purchasingPassId,
  });

  Pass? get selectedPass {
    final id = selectedPassId;
    if (id == null) return null;
    for (final pass in passes) {
      if (pass.id == id) return pass;
    }
    return null;
  }

  PassesData copyWith({
    User? user,
    List<Pass>? passes,
    Pass? activePass,
    String? selectedPassId,
    String? purchasingPassId,
  }) {
    return PassesData(
      user: user ?? this.user,
      passes: passes ?? this.passes,
      activePass: activePass ?? this.activePass,
      selectedPassId: selectedPassId,
      purchasingPassId: purchasingPassId,
    );
  }
}
class PassViewModel extends ChangeNotifier {
  final PassRepository _passRepository;
  final UserRepository _userRepository;

  AsyncValue<PassesData> _state = AsyncValue<PassesData>.loading();
  AsyncValue<PassesData> get state => _state;

  PassesData? get _data => _state.data;
  User? get currentUser => _data?.user;
  Pass? get currentPass => _data?.activePass;
  bool get hasCurrentPass => currentPass != null;
  List<Pass> get passes => _data?.passes ?? const [];
  Pass? get selectedPass => _data?.selectedPass;
  bool get isLoading => _state.state == AsyncValueState.loading;
  bool get isProcessingPayment => _data?.purchasingPassId != null;
  String? get error =>
      _state.state == AsyncValueState.error ? _state.error.toString() : null;
  User? get purchasedUserState => _data?.user;

  PassViewModel({
    required PassRepository passRepository,
    required UserRepository userRepository,
  }) : _passRepository = passRepository,
       _userRepository = userRepository;

  Future<void> loadPasses() async {
    _state = AsyncValue<PassesData>.loading();
    notifyListeners();

    try {
      final rawPasses = await _passRepository.getPasses();
      final user = await _userRepository.getCurrentUser();
      _state = AsyncValue<PassesData>.success(
        PassesData(user: user, passes: rawPasses, activePass: user.activePass),
      );
    } catch (e) {
      _state = AsyncValue<PassesData>.error('Failed to load passes: $e');
    }
    notifyListeners();
  }

  void selectPass(Pass selected) {
    final data = _data;
    if (data == null || data.activePass != null || data.purchasingPassId != null) return;
    _state = AsyncValue<PassesData>.success(
      data.copyWith(selectedPassId: selected.id, purchasingPassId: null),
    );
    notifyListeners();
  }

  Future<bool> processPayment() => purchasePass();

  Future<bool> purchasePass() async {
    final data = _data;
    final selected = data?.selectedPass;
    if (data == null || selected == null || data.purchasingPassId != null) return false;

    _state = AsyncValue<PassesData>.success(data.copyWith(purchasingPassId: selected.id));
    notifyListeners();

    try {
      final updatedUser = await _userRepository.setActivePass(selected);
      final nextPasses = data.passes
          .map((p) => Pass(
                id: p.id,
                type: p.type,
                price: p.price,
                startDate: p.startDate,
                endDate: p.endDate,
                isActive: p.id == selected.id,
              ))
          .toList(growable: false);
      _state = AsyncValue<PassesData>.success(
        PassesData(
          user: updatedUser,
          passes: nextPasses,
          activePass: updatedUser.activePass,
          selectedPassId: selected.id,
        ),
      );
      notifyListeners();
      return true;
    } catch (e) {
      _state = AsyncValue<PassesData>.error('Payment failed: $e');
      notifyListeners();
      return false;
    }
  }
}
