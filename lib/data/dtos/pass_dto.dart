import '../../model/pass.dart';

/// Data Transfer Object for Pass
/// Handles serialization/deserialization with Firebase
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

  /// Create PassDto from JSON (Firebase response)
  factory PassDto.fromJson(Map<String, dynamic> json) {
    return PassDto(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? 'day',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      startDate:
          json['startDate'] as String? ?? DateTime.now().toIso8601String(),
      endDate: json['endDate'] as String? ?? DateTime.now().toIso8601String(),
      isActive: json['isActive'] as bool? ?? false,
    );
  }

  /// Convert to JSON for Firebase
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

  /// Convert DTO to Pass model
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

  /// Create DTO from Pass model
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

  /// Parse PassType from string
  static PassType _parsePassType(String type) {
    return PassType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => PassType.day,
    );
  }

  /// Convert PassType to string
  static String _passTypeToString(PassType type) {
    return type.name;
  }

  @override
  String toString() =>
      'PassDto(id: $id, type: $type, price: $price, startDate: $startDate, endDate: $endDate, isActive: $isActive)';
}
