import 'package:flutter/foundation.dart';
import '../../../../model/station.dart';

class StationDetailsViewModel extends ChangeNotifier {
  late Station _currentStation;
  bool _isFavorite = false;
  final List<Station> _allStations;
  final Function(Station) _onStationChanged;

  // Getters
  Station get currentStation => _currentStation;
  bool get isFavorite => _isFavorite;
  List<Station> get allStations => _allStations;
  bool get isLowAvailability => _currentStation.availableBikes.length <= 2;
  bool get hasAvailableBikes => _currentStation.availableBikes.isNotEmpty;

  StationDetailsViewModel({
    required Station initialStation,
    required List<Station> allStations,
    required Function(Station) onStationChanged,
  }) : _currentStation = initialStation,
       _allStations = allStations,
       _onStationChanged = onStationChanged;

  /// Switch to a different station
  void switchStation(Station station) {
    _currentStation = station;
    _onStationChanged(station);
    notifyListeners();
  }

  /// Toggle favorite status
  void toggleFavorite() {
    _isFavorite = !_isFavorite;
    notifyListeners();
  }

  /// Book a bike from current station
  void bookBike() {
    if (hasAvailableBikes) {
      // TODO: Implement booking logic with repository
      notifyListeners();
    }
  }

  /// Get nearby stations (exclude current station)
  List<Station> getNearbyStations() {
    return _allStations.where((s) => s.id != _currentStation.id).toList();
  }
}
