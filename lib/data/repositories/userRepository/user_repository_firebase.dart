import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../dtos/pass_dto.dart';
import '../../dtos/user_dto.dart';
import '../../firebase/firebase_database.dart';
import '../../../model/pass.dart';
import '../../../model/user.dart';
import 'user_repository.dart';

/// Firebase implementation of UserRepository using Realtime Database
class UserRepositoryFirebase implements UserRepository {
  /// Get current user from Firebase
  ///
  /// For now, returns a default user with ID from local storage or environment
  /// In production, integrate with Firebase Authentication
  @override
  Future<User> getCurrentUser() async {
    try {
      final uri = FirebaseConfig.baseUri.replace(path: '/users/user_001.json');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic>? data =
            json.decode(response.body) as Map<String, dynamic>?;
        if (data != null) {
          return UserDto.fromJson(data).toModel();
        }
      }

      // Return default user if not found
      return const User(id: 'user_001', activePass: null);
    } catch (e) {
      // Return default user on error
      return const User(id: 'user_001', activePass: null);
    }
  }

  /// Set active pass for current user in Firebase
  @override
  Future<User> setActivePass(Pass? pass) async {
    try {
      final uri = FirebaseConfig.baseUri.replace(path: '/users/user_001.json');
      final userDto = UserDto(
        id: 'user_001',
        activePass: pass != null ? PassDto.fromModel(pass) : null,
      );

      final response = await http.patch(
        uri,
        body: json.encode(userDto.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return User(id: 'user_001', activePass: pass);
      }

      throw Exception('Failed to update user pass (${response.statusCode})');
    } catch (e) {
      throw Exception('Error setting active pass: $e');
    }
  }
}
