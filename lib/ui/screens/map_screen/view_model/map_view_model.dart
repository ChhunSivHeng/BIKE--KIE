import 'package:flutter/foundation.dart';

import '../../../../../data/repositories/stationRepository/station_repository.dart';
import '../../../../model/station.dart';
import '../../../../utils/async_value.dart';

class MapViewModel extends ChangeNotifier {
  final StationRepository _repo;

  MapViewModel(this._repo) {
    loadStations();
  }

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
      print('object');
      final stations = await _repo.getStations();

      _state = AsyncValue<List<Station>>.success(stations);
    } catch (e) {
      print(e);
      _state = AsyncValue.error('Failed to load stations.');
    }
    notifyListeners();
  }
}
