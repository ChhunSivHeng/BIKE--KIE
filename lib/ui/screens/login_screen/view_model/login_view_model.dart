import 'package:flutter/foundation.dart';
import '../../../../services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService;

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;
  bool get hasError => _errorMessage != null && _errorMessage!.isNotEmpty;

  LoginViewModel({required AuthService authService})
    : _authService = authService;

  String? validateUserId(String userId) {
    final trimmed = userId.trim();

    if (trimmed.isEmpty) {
      return 'Please enter a user ID';
    }

    if (trimmed.length < 3) {
      return 'User ID must be at least 3 characters';
    }

    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(trimmed)) {
      return 'User ID can only contain letters, numbers, and underscores';
    }

    return null;
  }

  Future<bool> login(String userId) async {
    final validation = validateUserId(userId);
    if (validation != null) {
      _setError(validation);
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      final success = await _authService.login(userId.trim());

      if (success) {
        _isSuccess = true;
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError('Login failed. Please check your user ID and try again.');
        return false;
      }
    } catch (e) {
      _setError('Network error: ${e.toString()}. Please try again.');
      return false;
    }
  }

  void clearError() {
    _clearError();
  }

  void clearSuccess() {
    _isSuccess = false;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    _isLoading = false;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
