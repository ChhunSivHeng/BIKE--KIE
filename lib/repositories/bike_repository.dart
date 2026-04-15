import '../model/bike.dart';

abstract class BikeRepository {
  Future<List<Bike>> getBikesByStation(String stationId);

  Future<void> updateBikeStatus({
    required String bikeId,
    required BikeStatus status,
  });
}
