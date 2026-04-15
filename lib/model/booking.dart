class Booking {
  final String id;
  final String bikeId;
  final String stationId;
  final DateTime bookingTime;

  final DateTime expiryTime;

  final bool isActive;

  const Booking({
    required this.id,
    required this.bikeId,
    required this.stationId,
    required this.bookingTime,
    required this.expiryTime,
    required this.isActive,
  });

  @override
  String toString() =>
      'Booking(id: $id, bikeId: $bikeId, stationId: $stationId, isActive: $isActive)';
}
