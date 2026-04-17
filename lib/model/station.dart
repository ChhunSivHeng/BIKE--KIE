class Station {
  final String id;
  final String name;
  final int totalSlots;
  final int availableBikes;
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

  bool get hasBikes => availableBikes > 0;

  @override
  String toString() =>
      'Station(id: $id, name: $name, totalSlots: $totalSlots, availableBikes: $availableBikes, latitude: $latitude, longitude: $longitude)';
}
