import 'package:flutter/foundation.dart';

import '../../../../../data/repositories/rentingRepository/renting_repository.dart';
import '../../../../../data/repositories/stationRepository/station_repository.dart';
import '../../../../../data/repositories/userRepository/user_repository.dart';
import '../../../../model/renting.dart';
import '../../../../model/station.dart';
import '../../../../model/user.dart';
import '../../../../utils/async_value.dart';

class MapViewModel extends ChangeNotifier {
  final StationRepository _stationRepo;
  final UserRepository _userRepo;
  final RentingRepository _rentingRepo;

  MapViewModel(this._stationRepo, this._userRepo, this._rentingRepo) {
    loadStations();
    loadUser();
  }

  // ── Stations ──────────────────────────────────────────────────────────────
  AsyncValue<List<Station>> _state = AsyncValue<List<Station>>.loading();
  AsyncValue<List<Station>> get data => _state;

  Future<void> loadStations({
    int minBike = 0,
    bool onlyShowAvailableBike = false,
  }) async {
    _state = AsyncValue.loading();
    notifyListeners();
    try {
      List<Station> stations = await _stationRepo.getStations();
      if (onlyShowAvailableBike) {
        stations = stations.where((s) => s.availableBikes.isNotEmpty).toList();
      }
      if (minBike > 0 || onlyShowAvailableBike) {
        stations = stations.where((s) => s.bikeAmounts >= minBike).toList();
      }
      _state = AsyncValue<List<Station>>.success(stations);
    } catch (e) {
      _state = AsyncValue.error('Failed to load stations.');
    }
    notifyListeners();
  }

  // ── User / Active Renting ─────────────────────────────────────────────────
  User? _user;
  Renting? _activeRenting;

  User? get user => _user;
  Renting? get activeRenting => _activeRenting;

  bool get hasPendingPickup =>
      _user?.activeBike != null && _activeRenting != null;

  Station? get pickupStation {
    if (_activeRenting == null) return null;
    final stations = _state.data;
    if (stations == null) return null;
    try {
      return stations.firstWhere((s) => s.id == _activeRenting!.stationId);
    } catch (_) {
      return null;
    }
  }

  Future<void> loadUser() async {
    try {
      _user = await _userRepo.getCurrentUser();
      if (_user?.activeBike != null) {
        await _loadActiveRenting();
      }
    } catch (e) {
      debugPrint('MapViewModel: failed to load user – $e');
    }
    notifyListeners();
  }

  Future<void> _loadActiveRenting() async {
    try {
      final rentings = await _rentingRepo.getRentings();
      final bikeId = _user!.activeBike!.id;
      final matches = rentings
          .where((r) => r.isActive && r.bikeId == bikeId)
          .toList();
      _activeRenting = matches.isNotEmpty ? matches.last : null;
    } catch (e) {
      debugPrint('MapViewModel: failed to load rentings – $e');
    }
  }

  /// Call this immediately after confirmRenting() succeeds.
  void refreshAfterRenting(Renting renting, User updatedUser) {
    _activeRenting = renting;
    _user = updatedUser;
    notifyListeners();
  }

  /// Called when the pickup countdown expires — clears reservation silently.
  Future<void> cancelPickup() async {
    try {
      await _userRepo.setActiveBike(null);
      _user = await _userRepo.getCurrentUser();
      _activeRenting = null;
      notifyListeners();
    } catch (e) {
      debugPrint('MapViewModel: failed to cancel pickup – $e');
    }
  }

  /// Called when user taps "I've Arrived" → "Unlock Bike".
  /// Marks the booking as picked up in Firebase and clears the banner.
  /// Returns true on success, false on error (so the UI can show a snackbar).
  Future<bool> confirmPickup() async {
    final renting = _activeRenting;
    final userId = _user?.id;

    if (renting == null || userId == null) {
      debugPrint('MapViewModel: confirmPickup called with no active renting');
      return false;
    }

    try {
      await _rentingRepo.confirmPickup(rentingId: renting.id, userId: userId);

      // Clear local state — banner disappears, pickup is done
      _activeRenting = null;
      _user = await _userRepo.getCurrentUser();
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('MapViewModel: failed to confirm pickup – $e');
      return false;
    }
  }
}
