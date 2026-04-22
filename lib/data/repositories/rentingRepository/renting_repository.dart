import '../../../model/bike.dart';
import '../../../model/renting.dart';

abstract class RentingRepository {
  Future<Renting> createRenting({
    required String userId,
    required Bike bike,
    required String stationId,
    required int slotIndex,
  });

  Future<List<Renting>> getRentings();

  Future<void> confirmPickup({
    required String rentingId,
    required String userId,
  });
}
