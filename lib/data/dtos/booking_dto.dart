import '../../model/booking.dart';

class BookingDto {
  static const String bikeIdKey = 'bikeId';
  static const String stationIdKey = 'stationId';
  static const String bookingTimeKey = 'bookingTime';
  static const String expiryTimeKey = 'expiryTime';
  static const String isActiveKey = 'isActive';

  static Booking fromJson(String id, Map<String, dynamic> json) {
    return Booking(
      id: id,
      bikeId: json[bikeIdKey] as String,
      stationId: json[stationIdKey] as String,
      bookingTime: DateTime.parse(json[bookingTimeKey] as String),
      expiryTime: DateTime.parse(json[expiryTimeKey] as String),
      isActive: json[isActiveKey] as bool,
    );
  }

  static Map<String, dynamic> toJson(Booking booking) {
    return {
      bikeIdKey: booking.bikeId,
      stationIdKey: booking.stationId,
      bookingTimeKey: booking.bookingTime.toIso8601String(),
      expiryTimeKey: booking.expiryTime.toIso8601String(),
      isActiveKey: booking.isActive,
    };
  }
}
