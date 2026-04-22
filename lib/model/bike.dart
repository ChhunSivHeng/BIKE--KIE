class Bike {
  final String id;
  final int? batteryLevel;

  const Bike({
    required this.id,
    this.batteryLevel,
  });

  @override
  String toString() =>
      'Bike(id: $id, batteryLevel: $batteryLevel)';
}
