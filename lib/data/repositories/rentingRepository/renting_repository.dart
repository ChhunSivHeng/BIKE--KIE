import '../../../model/renting.dart';

/// Abstract interface for booking data access
///
/// Allows:
/// - Swapping implementations (Firebase, Firestore, REST)
/// - Decoupling business logic from data source
/// - Easy testing through dependency injection
///
/// Implementation: BookingRepositoryFirebase (Firebase Realtime Database)
///
/// Provided by: main_dev.dart via Provider<BookingRepository>
abstract class RentingRepository {
  /// Create a new booking record in Firebase
  ///
  /// Endpoint: POST /bookings.json
  /// Returns: Booking object with generated ID from Firebase
  /// Throws: Exception if Firebase request fails
  Future<Renting> createRenting({
    required String bikeId,
    required String stationId,
  });

  /// Fetch all bookings from Firebase
  ///
  /// Endpoint: GET /bookings.json
  /// Returns: List of all booking records
  /// Returns: Empty list if no bookings exist
  Future<List<Renting>> getRentings();
}
