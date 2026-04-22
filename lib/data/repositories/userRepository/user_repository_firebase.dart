import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../dtos/bike_dto.dart';
import '../../dtos/pass_dto.dart';
import '../../dtos/user_dto.dart';
import '../../firebase/firebase_database.dart';
import '../../../model/bike.dart';
import '../../../model/pass.dart';
import '../../../model/user.dart';
import '../../../services/auth_service.dart';
import 'user_repository.dart';

class UserRepositoryFirebase implements UserRepository {
  final AuthService _authService;

  UserRepositoryFirebase({required AuthService authService})
    : _authService = authService;

  String get _currentUserId {
    final userId = _authService.currentUserId;
    if (userId == null || userId.isEmpty) {
      throw Exception('No user logged in');
    }
    return userId;
  }

  @override
  Future<User> getCurrentUser() async {
    try {
      final userId = _currentUserId;
      final uri = FirebaseConfig.baseUri.replace(path: '/users/$userId.json');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic>? data =
            json.decode(response.body) as Map<String, dynamic>?;
        if (data != null) {
          return UserDto.fromJson(data).toModel();
        }
      }
      return User(id: userId);
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  @override
  Future<User> setActivePass(Pass? pass) async {
    try {
      final userId = _currentUserId;
      final uri = FirebaseConfig.baseUri.replace(path: '/users/$userId.json');
      final userDto = UserDto(
        id: userId,
        activePass: pass != null ? PassDto.fromModel(pass) : null,
      );

      final response = await http.patch(
        uri,
        body: json.encode(userDto.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return User(id: userId, activePass: pass);
      }
      throw Exception('Failed to update user pass (${response.statusCode})');
    } catch (e) {
      throw Exception('Error setting active pass: $e');
    }
  }

  /// Stores the full bike object on the user node so batteryLevel is preserved.
  /// Pass null to clear the active bike (e.g. when returning).
  @override
  Future<User> setActiveBike(Bike? bike) async {
    try {
      final userId = _currentUserId;
      final uri = FirebaseConfig.baseUri.replace(path: '/users/$userId.json');

      final response = await http.patch(
        uri,
        body: json.encode({
          'activeBike': bike != null
              ? BikeDto.fromModel(bike).toUserJson()
              : null,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update user bike (${response.statusCode})');
      }

      // Re-fetch so activePass is preserved in the returned model
      return getCurrentUser();
    } catch (e) {
      throw Exception('Error setting active bike: $e');
    }
  }
}
