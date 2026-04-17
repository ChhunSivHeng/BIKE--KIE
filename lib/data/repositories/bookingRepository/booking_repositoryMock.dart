import '../../../model/booking.dart';
import 'booking_repository.dart';

class BookingRepositoryMock implements BookingRepository {
  int _callCount = 0;
  final List<Booking> _bookings = [];

  Future<void> _simulateNetwork() async {
    _callCount++;
    await Future.delayed(const Duration(seconds: 3));
    if (_callCount % 2 == 0) {
      throw Exception('Mock API Error');
    }
  }

  @override
  Future<Booking> createBooking({
    required String bikeId,
    required String stationId,
  }) async {
    await _simulateNetwork();
    final now = DateTime.now();
    final booking = Booking(
      id: 'booking_${_bookings.length + 1}',
      bikeId: bikeId,
      stationId: stationId,
      bookingTime: now,
      expiryTime: now.add(const Duration(minutes: 15)),
      isActive: true,
    );
    _bookings.add(booking);
    return booking;
  }

  @override
  Future<List<Booking>> getBookings() async {
    await _simulateNetwork();
    return List<Booking>.from(_bookings);
  }
}
