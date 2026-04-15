import 'pass.dart';

class User {
  final String id;

  final Pass? activePass;

  const User({
    required this.id,
    this.activePass,
  });

  @override
  String toString() => 'User(id: $id, activePass: $activePass)';
}
