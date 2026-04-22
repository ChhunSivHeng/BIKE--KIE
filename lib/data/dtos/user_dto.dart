import '../../model/user.dart';
import 'bike_dto.dart';
import 'pass_dto.dart';

class UserDto {
  final String id;
  final PassDto? activePass;
  final BikeDto? activeBike;

  UserDto({required this.id, this.activePass, this.activeBike});

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as String? ?? '',
      activePass: json['activePass'] != null && json['activePass'] != ''
          ? PassDto.fromJson(json['activePass'] as Map<String, dynamic>)
          : null,
      activeBike: json['activeBike'] != null
          ? BikeDto.fromUserJson(json['activeBike'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activePass': activePass?.toJson(),
      'activeBike': activeBike?.toUserJson(),
    };
  }

  User toModel() {
    return User(
      id: id,
      activePass: activePass?.toModel(),
      activeBike: activeBike?.toModel(),
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
