class Station {
  final String id;
  final String name;
  final int totalSlots;
  final int availableBikes;

  const Station({
    required this.id,
    required this.name,
    required this.totalSlots,
    required this.availableBikes,
  });

  @override
  String toString() =>
      'Station(id: $id, name: $name, totalSlots: $totalSlots, availableBikes: $availableBikes)';
}
