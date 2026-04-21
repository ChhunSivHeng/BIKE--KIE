import '../../model/renting.dart';

class RentingDto {
  static const String bikeIdKey = 'bikeId';
  static const String stationIdKey = 'stationId';
  static const String rentingTimeKey = 'bookingTime';
  static const String expiryTimeKey = 'expiryTime';
  static const String isActiveKey = 'isActive';

  static Renting fromJson(String id, Map<String, dynamic> json) {
    return Renting(
      id: id,
      bikeId: json[bikeIdKey] as String,
      stationId: json[stationIdKey] as String,
      rentingTime: DateTime.parse(json[rentingTimeKey] as String),
      expiryTime: DateTime.parse(json[expiryTimeKey] as String),
      isActive: json[isActiveKey] as bool,
    );
  }

  static Map<String, dynamic> toJson(Renting renting) {
    return {
      bikeIdKey: renting.bikeId,
      stationIdKey: renting.stationId,
      rentingTimeKey: renting.rentingTime.toIso8601String(),
      expiryTimeKey: renting.expiryTime.toIso8601String(),
      isActiveKey: renting.isActive,
    };
  }
}
