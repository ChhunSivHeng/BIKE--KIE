import '../../../model/pass.dart';
import '../../../model/user.dart';

/// Repository for managing user state and active pass
///
/// Implementation: UserRepositoryFirebase (Firebase Realtime Database)
/// Provided by: main_dev.dart via Provider<UserRepository>
abstract class UserRepository {
  /// Get current user from Firebase
  Future<User> getCurrentUser();

  /// Set active pass for current user in Firebase
  Future<User> setActivePass(Pass? pass);
}
