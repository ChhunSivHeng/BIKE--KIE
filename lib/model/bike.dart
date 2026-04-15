enum BikeStatus {
  available,
  empty,
}

class Bike {
  final String id;
  final String stationId;
  final BikeStatus status;
  final int batteryLevel;

  const Bike({
    required this.id,
    required this.stationId,
    required this.status,
    required this.batteryLevel,
  });

  @override
  String toString() =>
      'Bike(id: $id, stationId: $stationId, status: $status, batteryLevel: $batteryLevel)';
}
