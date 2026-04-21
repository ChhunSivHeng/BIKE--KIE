class Renting {
  final String id;
  final String bikeId;
  final String stationId;
  final DateTime rentingTime;

  final DateTime expiryTime;

  final bool isActive;

  const Renting({
    required this.id,
    required this.bikeId,
    required this.stationId,
    required this.rentingTime,
    required this.expiryTime,
    required this.isActive,
  });

  @override
  String toString() =>
      'Renting(id: $id, bikeId: $bikeId, stationId: $stationId, isActive: $isActive)';
}
