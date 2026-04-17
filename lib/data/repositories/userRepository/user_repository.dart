import '../../../model/pass.dart';
import '../../../model/user.dart';

abstract class UserRepository {
  Future<User> getCurrentUser();

  Future<User> setActivePass(Pass? pass);
}
