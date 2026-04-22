import '../../model/user.dart';
import 'bike_dto.dart';
import 'pass_dto.dart';

/// Data Transfer Object for User.
/// Handles serialization/deserialization with Firebase Realtime Database.
class UserDto {
  final String id;
  final PassDto? activePass;
  final BikeDto? activeBike; // full bike object, not just id

  UserDto({required this.id, this.activePass, this.activeBike});

  /// Create UserDto from Firebase JSON response
  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as String? ?? '',
      activePass: json['activePass'] != null && json['activePass'] != ''
          ? PassDto.fromJson(json['activePass'] as Map<String, dynamic>)
          : null,
      // Stored as { "id": "...", "batteryLevel": 75 }
      activeBike: json['activeBike'] != null
          ? BikeDto.fromUserJson(json['activeBike'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Convert to JSON for Firebase PATCH
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activePass': activePass?.toJson(),
      'activeBike': activeBike?.toUserJson(),
    };
  }

  /// Convert DTO → domain model
  /// Previously activeBike was never mapped — fixed here.
  User toModel() {
    return User(
      id: id,
      activePass: activePass?.toModel(),
      activeBike: activeBike?.toModel(), // ← was missing before
    );
  }

  factory UserDto.fromModel(User user) {
    return UserDto(
      id: user.id,
      activePass: user.activePass != null
          ? PassDto.fromModel(user.activePass!)
          : null,
      activeBike: user.activeBike != null
          ? BikeDto.fromModel(user.activeBike!)
          : null,
    );
  }

  @override
  String toString() =>
      'UserDto(id: $id, activePass: $activePass, activeBike: $activeBike)';
}
