import '../../../model/bike.dart';
import '../../../model/renting.dart';

abstract class RentingRepository {
  /// Creates a renting record, removes the bike from the station slot,
  /// and assigns the bike to the user — all in one call.
  ///
  /// [bike]      full Bike object (id + batteryLevel) so Firebase can store
  ///             the complete activeBike on the user node.
  /// [slotIndex] index inside station.availableBikes[] to null out.
  Future<Renting> createRenting({
    required String userId,
    required Bike bike,
    required String stationId,
    required int slotIndex,
  });

  Future<List<Renting>> getRentings();
}
