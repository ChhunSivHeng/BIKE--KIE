enum PassType {
  day,
  monthly,
  annual,
}

class Pass {
  final String id;
  final PassType type;
  final double price;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;

  const Pass({
    required this.id,
    required this.type,
    required this.price,
    required this.startDate,
    required this.endDate,
    required this.isActive,
  });
}
