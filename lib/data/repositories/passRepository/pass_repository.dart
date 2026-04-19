import '../../../model/pass.dart';

/// Repository for managing passes (subscriptions and tickets)
///
/// Implementation: PassRepositoryFirebase (Firebase Realtime Database)
/// Provided by: main_dev.dart via Provider<PassRepository>
abstract class PassRepository {
  /// Get all available passes from Firebase
  ///
  /// Endpoint: GET /passes.json
  /// Returns: List of all pass offerings (day, monthly, annual)
  Future<List<Pass>> getPasses();

  /// Create a new temporary ticket (single-use pass) in Firebase
  ///
  /// Used for buying single-hour tickets
  /// Endpoint: PUT /passes/{ticketId}
  /// Returns: Pass object with generated ticket ID
  Future<Pass> createTicket({
    required String userId,
    required PassType type,
    required double price,
  });
}
