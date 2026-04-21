import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../dtos/pass_dto.dart';
import '../../dtos/user_dto.dart';
import '../../firebase/firebase_database.dart';
import '../../../model/pass.dart';
import '../../../model/user.dart';
import '../../../services/auth_service.dart';
import 'user_repository.dart';

/// Firebase implementation of UserRepository using Realtime Database
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

  /// Get current user from Firebase
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

      // Return default user if not found
      return User(id: userId, activePass: null);
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  /// Set active pass for current user in Firebase
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
}
