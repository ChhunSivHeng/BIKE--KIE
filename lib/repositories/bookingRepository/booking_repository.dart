import '../../model/booking.dart';

abstract class BookingRepository {
  Future<Booking> createBooking({
    required String bikeId,
    required String stationId,
  });

  Future<List<Booking>> getBookings();
}
