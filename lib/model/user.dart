import 'bike.dart';

import 'pass.dart';

class User {
  final String id;

  final Pass? activePass;
  final Bike? activeBike;

  const User({required this.id, this.activePass, this.activeBike});

  @override
  String toString() => 'User(id: $id, activePass: $activePass, activeBike: $activeBike)';
}
