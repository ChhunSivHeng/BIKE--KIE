import '../../../model/bike.dart';
import '../../../model/renting.dart';

abstract class RentingRepository {
  /// Creates a renting record, removes the bike from the station slot,
  /// and assigns the bike to the user — all in one call.
  Future<Renting> createRenting({
    required String userId,
    required Bike bike,
    required String stationId,
    required int slotIndex,
  });

  Future<List<Renting>> getRentings();

  /// Confirms the user has physically picked up the bike.
  /// - Marks the booking as picked up (isActive stays true, pickedUp = true)
  /// - Clears the expiryTime pressure (bike is now in use, not just reserved)
  /// - Removes activeBike reservation flag from user (they now own it via renting)
  Future<void> confirmPickup({
    required String rentingId,
    required String userId,
  });
}
