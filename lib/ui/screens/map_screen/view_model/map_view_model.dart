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

  Future<void> loadStations({
    int minBike = 0,
    bool onlyShowAvailableBike = false,
  }) async {
    _state = AsyncValue.loading();
    notifyListeners();

    try {
      print('object');
      List<Station> stations = await _repo.getStations();

      if (onlyShowAvailableBike) {
        stations = stations.where((s) => s.availableBikes.isNotEmpty).toList();
      }
      if (minBike > 0 || onlyShowAvailableBike) {
        stations = stations.where((s) => s.bikeAmounts >= minBike).toList();
      }

      _state = AsyncValue<List<Station>>.success(stations);
    } catch (e) {
      print(e);
      _state = AsyncValue.error('Failed to load stations.');
    }
    notifyListeners();
  }
}
