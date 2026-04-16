class Station {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final int availableBikes;

  const Station({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.availableBikes,
  });

  bool get hasBikes => availableBikes > 0;
}
