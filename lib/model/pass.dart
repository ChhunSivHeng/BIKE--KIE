enum PassType {
  day,
  monthly,
  annual,
}

extension PassTypeExtension on PassType {
  int get priority {
    switch (this) {
      case PassType.day:
        return 1;
      case PassType.monthly:
        return 2;
      case PassType.annual:
        return 3;
    }
  }

  bool isUpgradeTo(PassType other) {
    return other.priority > priority;
  }
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
