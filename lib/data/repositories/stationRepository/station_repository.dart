import '../../../model/station.dart';

abstract class StationRepository {
  Future<List<Station>> getStations();
  Future<void> removeBikeFromStation(String stationId, int slotIndex);
}
