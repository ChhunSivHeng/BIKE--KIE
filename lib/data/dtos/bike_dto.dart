import '../../model/bike.dart';

class BikeDto {
  final String id;
  final int? batteryLevel;

  BikeDto({required this.id, this.batteryLevel});


  static Bike fromJson(dynamic json) {
    final entry = (json as Map<String, dynamic>).entries.first;
    return Bike(
      id: entry.key,
      batteryLevel: entry.value == 'n/a' ? null : entry.value as int?,
    );
  }


  factory BikeDto.fromUserJson(Map<String, dynamic> json) {
    return BikeDto(
      id: json['id'] as String? ?? '',
      batteryLevel: json['batteryLevel'] as int?,
    );
  }

  Map<String, dynamic> toUserJson() => {'id': id, 'batteryLevel': batteryLevel};

  Bike toModel() => Bike(id: id, batteryLevel: batteryLevel);

  factory BikeDto.fromModel(Bike bike) =>
      BikeDto(id: bike.id, batteryLevel: bike.batteryLevel);
}
