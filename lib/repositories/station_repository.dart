import '../model/station.dart';

abstract class StationRepository {
  Future<List<Station>> getStations();
}
