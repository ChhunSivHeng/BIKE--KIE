import '../../model/bike.dart';

class BikeDto {
  static Bike fromJson(dynamic json) {
    final entry = (json as Map<String, dynamic>).entries.first;

    return Bike(
      id: entry.key,
      batteryLevel: entry.value == 'n/a' ? null : entry.value,
    );
  }
}
