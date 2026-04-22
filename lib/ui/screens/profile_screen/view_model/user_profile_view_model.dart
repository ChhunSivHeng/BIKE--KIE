import 'package:flutter/foundation.dart';
import '../../../../model/user.dart';
import '../../../../model/pass.dart';
import '../../../../data/repositories/userRepository/user_repository.dart';
import '../../../../services/auth_service.dart';

class UserProfileViewModel extends ChangeNotifier {
  final UserRepository _userRepository;
  final AuthService _authService;

  User? _user;
  bool _isLoading = true;
  String? _error;
  bool _isLoggingOut = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggingOut => _isLoggingOut;

  Pass? get activePass => _user?.activePass;
  bool get hasActivePass => _user?.activePass != null;
  String? get passType => _user?.activePass?.type.name.toUpperCase();
  String? get passValidUntil =>
      _user?.activePass?.endDate.toString().split(' ')[0];
  String? get passPrice => _user?.activePass?.price.toString();

  String get userDisplayName => _authService.currentUserId ?? 'User';
  String get userEmail => _authService.currentUserId != null
      ? _authService.getUserEmail(_authService.currentUserId!)
      : 'user@bikkie.app';

  UserProfileViewModel({
    required UserRepository userRepository,
    required AuthService authService,
  }) : _userRepository = userRepository,
       _authService = authService {
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final user = await _userRepository.getCurrentUser();
      _user = user;
    } catch (e) {
      _error = 'Failed to load user profile: $e';
      debugPrint('Error loading user: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> refreshUserData() async {
    await _loadUser();
  }

  Future<bool> logout() async {
    try {
      _isLoggingOut = true;
      notifyListeners();

      final success = await _authService.logout();

      if (success) {
        _user = null;
        _error = null;
        debugPrint('User logged out successfully');
      } else {
        _error = 'Failed to logout';
      }

      return success;
    } catch (e) {
      _error = 'Logout error: $e';
      debugPrint('Error during logout: $e');
      return false;
    } finally {
      _isLoggingOut = false;
      notifyListeners();
    }
  }
}
