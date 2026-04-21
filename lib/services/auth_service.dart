import 'package:flutter/foundation.dart';

/// Authentication service for managing user sessions
///
/// Handles:
/// - User login (stores user ID in memory)
/// - User logout (clears user ID)
/// - Current user retrieval
/// - Login state tracking
///
/// For production: Integrate with Firebase Auth
class AuthService extends ChangeNotifier {
  static String? _currentUserId;

  String? get currentUserId => _currentUserId;
  bool get isLoggedIn => _currentUserId != null && _currentUserId!.isNotEmpty;

  /// Initialize auth service
  Future<void> initialize() async {
    // For now, start with no user logged in
    // In production, restore from persistent storage or Firebase Auth
    notifyListeners();
  }

  /// Login with user ID (can be extended with email/password)
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

  /// Logout current user
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

  /// Get user name (can be fetched from Firebase Auth)
  String getUserDisplayName(String userId) {
    // Extract username from userId format (e.g., "user_001" -> "User")
    return 'User';
  }

  /// Get user email (can be fetched from Firebase Auth)
  String getUserEmail(String userId) {
    return '$userId@bikkie.app';
  }
}
