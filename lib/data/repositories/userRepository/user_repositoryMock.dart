import '../../../model/pass.dart';
import '../../../model/user.dart';
import 'user_repository.dart';

class UserRepositoryMock implements UserRepository {
  int _callCount = 0;
  User _user = const User(id: 'user_1');

  Future<void> _simulateNetwork() async {
    _callCount++;
    await Future.delayed(const Duration(seconds: 3));
    if (_callCount % 2 == 0) {
      throw Exception('Mock API Error');
    }
  }

  @override
  Future<User> getCurrentUser() async {
    await _simulateNetwork();
    return _user;
  }

  @override
  Future<User> setActivePass(Pass? pass) async {
    await _simulateNetwork();
    _user = User(id: _user.id, activePass: pass);
    return _user;
  }
}
