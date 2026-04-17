import '../../model/bike.dart';
import '../../model/station.dart';
import 'bike_dto.dart';

class StationDto {
  static const String nameKey = "name";
  static const String totalSlotsKey = "totalSlots";
  static const String latitudeKey = "latitude";
  static const String longitudeKey = "longitude";
  static const String availableBikesKey = "availableBikes";

  static Station fromJson(String id, Map<String, dynamic> json) {
    assert(json[nameKey] is String);
    assert(json[totalSlotsKey] is int);
    assert(json[latitudeKey] is double);
    assert(json[longitudeKey] is double);

    List<Bike?> bikes;

    if (json[availableBikesKey] is List) {
      bikes = json[availableBikesKey]
          .map<Bike?>((bike) => bike == null ? null : BikeDto.fromJson(bike))
          .toList();
    } else {
      bikes = [];
    }

    return Station(
      id: id,
      name: json[nameKey],
      totalSlots: json[totalSlotsKey],
      latitude: json[latitudeKey],
      longitude: json[longitudeKey],
      availableBikes: bikes,
    );
  }
}
