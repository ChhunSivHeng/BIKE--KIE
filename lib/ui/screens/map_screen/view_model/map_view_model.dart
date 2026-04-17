import 'package:flutter/foundation.dart';

import '../../../../../data/repositories/stationRepository/station_repository.dart';
import '../../../../model/station.dart';
import '../../../../utils/async_value.dart';

class MapViewModel extends ChangeNotifier {
  final StationRepository _repo;

  MapViewModel(this._repo);

  AsyncValue<List<Station>> _state = AsyncValue<List<Station>>.loading();
  AsyncValue<List<Station>> get data => _state;

  ({double lat, double lng}) _coordsForId(String id) {
    switch (id) {
      case 'toul_kork':
        return (lat: 11.5715, lng: 104.8904);
      case 'olympic':
        return (lat: 11.5569, lng: 104.9156);
      case 'orussey':
        return (lat: 11.5763, lng: 104.9241);
      default:
        return (lat: 11.5564, lng: 104.9282);
    }
  }

  Future<void> loadStations() async {
    _state = AsyncValue.loading();
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

      _state = AsyncValue<List<Station>>.success(stations);
    } catch (_) {
      _state = AsyncValue.error('Failed to load stations.');
    }
    notifyListeners();
  }
}
