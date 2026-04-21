import 'package:flutter/foundation.dart';

import '../../../../data/repositories/passRepository/pass_repository.dart';
import '../../../../data/repositories/userRepository/user_repository.dart';
import '../../../../model/pass.dart';
import '../../../../model/user.dart';

/// ViewModel for Pass Screen
///
/// Manages:
/// - Loading all available passes from PassRepository (Firebase)
/// - Pass selection and purchase with Firebase persistence
/// - User pass state updates via UserRepository
///
/// Requires PassRepository and UserRepository to be injected via dependency injection.
class PassViewModel extends ChangeNotifier {
  final PassRepository _passRepository;
  final UserRepository _userRepository;

  bool isLoading = false;
  bool isProcessingPayment = false;
  List<Pass> passes = [];
  Pass? selectedPass;
  String? error;
  User? purchasedUserState;
  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get hasCurrentPass => _currentUser?.activePass != null;
  Pass? get currentPass => _currentUser?.activePass;

  PassViewModel({
    required PassRepository passRepository,
    required UserRepository userRepository,
  }) : _passRepository = passRepository,
       _userRepository = userRepository;

  void _notify() {
    notifyListeners();
  }

  /// Load available passes and user's current pass status
  Future<void> loadPasses() async {
    isLoading = true;
    error = null;
    _notify();

    try {
      // Load both available passes and user's current pass
      final rawPasses = await _passRepository.getPasses();
      final user = await _userRepository.getCurrentUser();

      _currentUser = user;
      passes = rawPasses;
      selectedPass = null;
    } catch (e) {
      error = 'Failed to load passes: $e';
      debugPrint('Error loading passes: $e');
    }

    isLoading = false;
    _notify();
  }

  /// Select a pass for purchase
  void selectPass(Pass selected) {
    if (isLoading || error != null) {
      return;
    }

    selectedPass = selected;
    _notify();
  }

  /// Process payment and save pass to Firebase
  ///
  /// Flow:
  /// 1. Validate payment state
  /// 2. Create pass copy with startDate set to today
  /// 3. Call UserRepository.setActivePass() to persist in Firebase
  /// 4. Update purchasedUserState with new user data
  /// 5. Return true on success (so caller can navigate back)
  ///
  /// Returns: true if purchase successful, false otherwise
  Future<bool> processPayment() async {
    if (isLoading || selectedPass == null || isProcessingPayment) {
      return false;
    }

    final selected = selectedPass!;
    isProcessingPayment = true;
    _notify();

    try {
      // Simulate payment processing (could be replaced with real payment service)
      await Future.delayed(const Duration(milliseconds: 500));

      // Set pass as active and persist to Firebase
      final updatedUser = await _userRepository.setActivePass(selected);
      purchasedUserState = updatedUser;

      // Update passes list to show purchased pass as active
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
      error = null;
      isProcessingPayment = false;
      _notify();

      return true;
    } catch (e) {
      error = 'Payment failed: $e';
      debugPrint('Error processing payment: $e');
      isProcessingPayment = false;
      _notify();
      return false;
    }
  }
}
