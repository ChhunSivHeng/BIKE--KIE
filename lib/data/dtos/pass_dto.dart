import '../../model/pass.dart';

class PassDto {
  final String id;
  final String type;
  final double price;
  final String startDate;
  final String endDate;
  final bool isActive;

  PassDto({
    required this.id,
    required this.type,
    required this.price,
    required this.startDate,
    required this.endDate,
    required this.isActive,
  });

  factory PassDto.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();

    final type = (json['type'] as String?) ?? 'day';

    final startDate = json['startDate'] != null
        ? DateTime.parse(json['startDate'])
        : now;

    DateTime endDate;
    if (json['endDate'] != null) {
      endDate = DateTime.parse(json['endDate']);
    } else {
      switch (type.toLowerCase()) {
        case 'monthly':
          endDate = DateTime(
            startDate.year,
            startDate.month + 1,
            startDate.day,
          );
          break;
        case 'annual':
          endDate = DateTime(
            startDate.year + 1,
            startDate.month,
            startDate.day,
          );
          break;
        case 'day':
        default:
          endDate = startDate.add(const Duration(days: 1));
          break;
      }
    }

    return PassDto(
      id: json['id'] as String? ?? '',
      type: type,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      startDate: startDate.toIso8601String(),
      endDate: endDate.toIso8601String(),
      isActive: json['isActive'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'price': price,
      'startDate': startDate,
      'endDate': endDate,
      'isActive': isActive,
    };
  }

  Pass toModel() {
    return Pass(
      id: id,
      type: _parsePassType(type),
      price: price,
      startDate: DateTime.parse(startDate),
      endDate: DateTime.parse(endDate),
      isActive: isActive,
    );
  }

  factory PassDto.fromModel(Pass pass) {
    return PassDto(
      id: pass.id,
      type: _passTypeToString(pass.type),
      price: pass.price,
      startDate: pass.startDate.toIso8601String(),
      endDate: pass.endDate.toIso8601String(),
      isActive: pass.isActive,
    );
  }

  static PassType _parsePassType(String type) {
    return PassType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => PassType.day,
    );
  }

  static String _passTypeToString(PassType type) {
    return type.name;
  }

  @override
  String toString() =>
      'PassDto(id: $id, type: $type, price: $price, startDate: $startDate, endDate: $endDate, isActive: $isActive)';
}
