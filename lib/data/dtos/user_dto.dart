import 'dart:convert';

import '../../model/user.dart';
import 'pass_dto.dart';

/// Data Transfer Object for User
/// Handles serialization/deserialization with Firebase
class UserDto {
  final String id;
  final PassDto? activePass;

  UserDto({required this.id, this.activePass});

  /// Create UserDto from JSON (Firebase response)
  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as String? ?? '',
      activePass: json['activePass'] != null
          ? PassDto.fromJson(json['activePass'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Convert to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {'id': id, 'activePass': activePass?.toJson()};
  }

  /// Convert DTO to User model
  User toModel() {
    return User(id: id, activePass: activePass?.toModel());
  }

  /// Create DTO from User model
  factory UserDto.fromModel(User user) {
    return UserDto(
      id: user.id,
      activePass: user.activePass != null
          ? PassDto.fromModel(user.activePass!)
          : null,
    );
  }

  @override
  String toString() => 'UserDto(id: $id, activePass: $activePass)';
}
