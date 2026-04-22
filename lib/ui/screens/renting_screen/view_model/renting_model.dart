import 'package:flutter/foundation.dart';
import '../../../../model/bike.dart';
import '../../../../model/pass.dart';
import '../../../../model/station.dart';
import '../../../../model/user.dart';
import '../../../../data/repositories/rentingRepository/renting_repository.dart';
import '../../../../data/repositories/userRepository/user_repository.dart';
import '../../../../data/repositories/passRepository/pass_repository.dart';

class RentingViewModel extends ChangeNotifier {
  final Station? _station;
  final Bike? _selectedBike;
  final int? _selectedSlotIndex;

  final RentingRepository _rentingRepository;
  final UserRepository _userRepository;
  final PassRepository _passRepository;

  User _user = const User(id: 'user_001', activePass: null);
  bool _isLoadingUser = true;
  String? _error;

  RentingViewModel({
    Station? station,
    Bike? selectedBike,
    int? selectedSlotIndex,
    required RentingRepository rentingRepository,
    required UserRepository userRepository,
    required PassRepository passRepository,
  }) : _station = station,
       _selectedBike = selectedBike,
       _selectedSlotIndex = selectedSlotIndex,
       _rentingRepository = rentingRepository,
       _userRepository = userRepository,
       _passRepository = passRepository {
    _initializeUser();
  }

  // ── Getters ──────────────────────────────────────────────────────────────────

  bool get hasActiveBike => _user.activeBike != null;
  String? get activeBikeId => _user.activeBike?.id;
  int? get activeBikeRange => _user.activeBike?.batteryLevel;

  Station? get station => _station;
  User get user => _user;
  bool get isLoadingUser => _isLoadingUser;
  String? get error => _error;

  bool get hasActivePass => _user.activePass != null;

  String? get activePassType => _user.activePass?.type.name.replaceFirst(
    _user.activePass!.type.name[0],
    _user.activePass!.type.name[0].toUpperCase(),
  );

  String? get activePassEndDate =>
      _user.activePass?.endDate.toString().split(' ')[0];

  // ── Init ─────────────────────────────────────────────────────────────────────

  Future<void> _initializeUser() async {
    try {
      _isLoadingUser = true;
      notifyListeners();
      _user = await _userRepository.getCurrentUser();
      _error = null;
    } catch (e) {
      _error = 'Failed to load user: $e';
      debugPrint('Error loading user: $e');
      _user = const User(id: 'user_001', activePass: null);
    } finally {
      _isLoadingUser = false;
      notifyListeners();
    }
  }

  // ── Renting ──────────────────────────────────────────────────────────────────

  /// Single call that:
  ///   1. Creates booking in Firebase
  ///   2. Stores full activeBike object on user node (preserves batteryLevel)
  ///   3. Nulls out the station slot
  ///   4. Updates local user state
  Future<void> confirmRenting() async {
    if (_station == null) {
      throw Exception('No station selected for bike renting');
    }

    final Bike bike;
    final int slotIndex;

    if (_selectedBike != null && _selectedSlotIndex != null) {
      bike = _selectedBike;
      slotIndex = _selectedSlotIndex;
    } else {
      final entry = _station.availableBikeEntries.firstOrNull;
      if (entry == null) {
        throw Exception('No available bike at selected station');
      }
      bike = entry.value;
      slotIndex = entry.key;
    }

    // Pass full Bike so Firebase stores batteryLevel alongside id
    await _rentingRepository.createRenting(
      userId: _user.id,
      bike: bike,
      stationId: _station.id,
      slotIndex: slotIndex,
    );

    // Reflect change locally immediately
    _user = User(id: _user.id, activePass: _user.activePass, activeBike: bike);
    notifyListeners();

    debugPrint(
      'Renting confirmed — station: ${_station.name}, bike: ${bike.id}, slot: $slotIndex',
    );
  }

  // ── Pass / Ticket ────────────────────────────────────────────────────────────

  Future<void> buyAndSetPass(Pass passSelected) async {
    try {
      _user = await _userRepository.setActivePass(passSelected);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to purchase pass: $e';
      debugPrint('Error buying pass: $e');
      rethrow;
    }
  }

  Future<void> buySingleTicket() async {
    try {
      final ticket = await _passRepository.createTicket(
        userId: _user.id,
        type: PassType.day,
        price: 5.0,
      );
      _user = await _userRepository.setActivePass(ticket);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to purchase ticket: $e';
      debugPrint('Error buying ticket: $e');
      rethrow;
    }
  }

  void updateUserWithPass(User userWithPass) {
    _user = userWithPass;
    _error = null;
    debugPrint('User updated with pass: ${userWithPass.activePass?.type.name}');
    notifyListeners();
  }

  Future<void> refreshUserData() async {
    try {
      _isLoadingUser = true;
      notifyListeners();
      _user = await _userRepository.getCurrentUser();
      _error = null;
    } catch (e) {
      _error = 'Failed to refresh user: $e';
      debugPrint('Error refreshing user: $e');
    } finally {
      _isLoadingUser = false;
      notifyListeners();
    }
  }
}
