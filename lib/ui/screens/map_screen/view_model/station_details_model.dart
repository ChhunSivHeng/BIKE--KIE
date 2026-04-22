import 'package:flutter/foundation.dart';
import '../../../../model/bike.dart';
import '../../../../model/station.dart';

class StationDetailsViewModel extends ChangeNotifier {
  late Station _currentStation;
  bool _isFavorite = false;
  final List<Station> _allStations;
  final Function(Station) _onStationChanged;
  final void Function({Bike? selectedBike, int? selectedSlotIndex})
  _onRentRequested;

  Station get currentStation => _currentStation;
  bool get isFavorite => _isFavorite;
  List<Station> get allStations => _allStations;
  bool get isLowAvailability => _currentStation.availableBikes.length <= 2;
  bool get hasAvailableBikes => _currentStation.availableBikes.isNotEmpty;

  StationDetailsViewModel({
    required Station initialStation,
    required List<Station> allStations,
    required Function(Station) onStationChanged,
    required void Function({Bike? selectedBike, int? selectedSlotIndex})
    onRentRequested,
  }) : _currentStation = initialStation,
       _allStations = allStations,
       _onStationChanged = onStationChanged,
       _onRentRequested = onRentRequested;

  void switchStation(Station station) {
    _currentStation = station;
    _onStationChanged(station);
    notifyListeners();
  }

  void toggleFavorite() {
    _isFavorite = !_isFavorite;
    notifyListeners();
  }

  void handleRentBike({Bike? selectedBike, int? selectedSlotIndex}) {
    if (!hasAvailableBikes) return;
    _onRentRequested(
      selectedBike: selectedBike,
      selectedSlotIndex: selectedSlotIndex,
    );
  }

  void rentSelectedBike({required Bike bike, required int slotIndex}) {
    handleRentBike(
      selectedBike: bike,
      selectedSlotIndex: slotIndex,
    );
  }

  List<Station> getNearbyStations() {
    return _allStations.where((s) => s.id != _currentStation.id).toList();
  }
}
