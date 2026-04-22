import '../../model/bike.dart';

class BikeDto {
  final String id;
  final int? batteryLevel;

  BikeDto({required this.id, this.batteryLevel});

  // ── Station bikes ─────────────────────────────────────────────────────────
  // Format in Firebase: { "bikeId": batteryLevel } or { "bikeId": "n/a" }

  static Bike fromJson(dynamic json) {
    final entry = (json as Map<String, dynamic>).entries.first;
    return Bike(
      id: entry.key,
      batteryLevel: entry.value == 'n/a' ? null : entry.value as int?,
    );
  }

  // ── User's activeBike ─────────────────────────────────────────────────────
  // Format in Firebase: { "id": "bike123", "batteryLevel": 75 }

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
