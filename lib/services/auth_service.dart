import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  static String? _currentUserId;

  String? get currentUserId => _currentUserId;
  bool get isLoggedIn => _currentUserId != null && _currentUserId!.isNotEmpty;

  Future<void> initialize() async {
    notifyListeners();
  }

  Future<bool> login(String userId) async {
    try {
      _currentUserId = userId;
      notifyListeners();
      debugPrint('User logged in: $userId');
      return true;
    } catch (e) {
      debugPrint('Error logging in: $e');
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      _currentUserId = null;
      notifyListeners();
      debugPrint('User logged out');
      return true;
    } catch (e) {
      debugPrint('Error logging out: $e');
      return false;
    }
  }

  String getUserDisplayName(String userId) {
    return 'User';
  }

  String getUserEmail(String userId) {
    return '$userId@bikkie.app';
  }
}
