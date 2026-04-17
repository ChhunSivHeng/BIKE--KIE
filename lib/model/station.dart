import 'bike.dart';

class Station {
  final String id;
  final String name;
  final int totalSlots;
  final List<Bike?> availableBikes;
  final double? latitude;
  final double? longitude;

  const Station({
    required this.id,
    required this.name,
    required this.totalSlots,
    required this.availableBikes,
    this.latitude,
    this.longitude,
  });

  int get bikeAmounts => availableBikes.length;

  @override
  String toString() =>
      'Station(id: $id, name: $name, totalSlots: $totalSlots, availableBikes: $availableBikes, latitude: $latitude, longitude: $longitude)';
}
