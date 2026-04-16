import '../../model/station.dart';
import '../mockData.dart';
import 'station_repository.dart';

class StationRepositoryMock implements StationRepository {
  Future<void> _simulateNetwork() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future<List<Station>> getStations() async {
    await _simulateNetwork();
    return List<Station>.unmodifiable(MockData.stationRepositoryStations);
  }
}
