import 'package:flutter/foundation.dart';

import '../../../../../data/repositories/stationRepository/station_repository.dart';
import '../../../../../data/repositories/stationRepository/station_repositoryMock.dart';
import '../states/station_state.dart';

class MapViewModel extends ChangeNotifier {
  final StationRepository _repo;

  MapViewModel({StationRepository? repo})
    : _repo = repo ?? StationRepositoryMock();

  StationState _state = StationState.loading();
  StationState get state => _state;

  ({double lat, double lng}) _coordsForId(String id) {
    switch (id) {
      case 'toul_kork':
        return (lat: 11.5715, lng: 104.8904);
      case 'olympic':
        return (lat: 11.5569, lng: 104.9156);
      case 'orussey':
        return (lat: 11.5639, lng: 104.9242);
      default:
        return (lat: 11.5564, lng: 104.9282);
    }
  }

  Future<void> loadStations() async {
    _state = StationState.loading();
    notifyListeners();

    try {
      final rawStations = await _repo.getStations();

      final stations = rawStations
          .map((s) {
            final c = _coordsForId(s.id);
            return Station(
              id: s.id,
              name: s.name,
              totalSlots: s.totalSlots,
              latitude: c.lat,
              longitude: c.lng,
              availableBikes: s.availableBikes,
            );
          })
          .toList(growable: false);

      _state = StationState.success(stations);
      notifyListeners();
    } catch (_) {
      _state = StationState.error('Failed to load stations.');
      notifyListeners();
    }
  }
}
