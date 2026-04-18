import '../../../model/booking.dart';

/// 🏗️ REPOSITORY PATTERN (W5: DI & Abstraction)
///
/// This is the ABSTRACT interface. Why?
///
/// 1️⃣ SEPARATION OF CONCERNS
/// - ViewModel doesn't know if data comes from API, Firebase, mock, etc.
/// - Easy to swap implementations without changing ViewModel
///
/// 2️⃣ TESTABILITY
/// - Create MockBookingRepository for testing
/// - Inject mock in tests, real in production
///
/// 3️⃣ DEPENDENCY INJECTION
/// - main_dev.dart provides concrete implementation
/// - ViewModel receives it via constructor or context.read<>
///
/// IMPLEMENTATION OPTIONS:
/// - BookingRepositoryMock (in dev)
/// - BookingRepositoryFirebase (if using Firebase)
/// - BookingRepositoryRest (if using REST API)
/// All implement this abstract interface!
abstract class BookingRepository {
  Future<Booking> createBooking({
    required String bikeId,
    required String stationId,
  });

  Future<List<Booking>> getBookings();
}
