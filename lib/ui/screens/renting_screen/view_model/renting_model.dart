import 'package:flutter/foundation.dart';
import '../../../../model/pass.dart';
import '../../../../model/station.dart';
import '../../../../model/user.dart';
import '../../../../data/repositories/rentingRepository/renting_repository.dart';
import '../../../../data/repositories/userRepository/user_repository.dart';
import '../../../../data/repositories/passRepository/pass_repository.dart';

/// ViewModel for Booking Screen
///
/// Manages:
/// - Station selection and user state
/// - Pass management via UserRepository (Firebase)
/// - Ticket purchases via PassRepository (Firebase)
/// - Booking confirmation flow via BookingRepository (Firebase)
///
/// Architecture:
/// - Receives Station from BookingScreen
/// - Injects all repositories via dependency injection
/// - Loads current user from Firebase on initialization
/// - Broadcasts state changes via notifyListeners() to UI
///
/// Data Flow:
/// 1. Confirm booking: confirmBooking() → BookingRepository.createBooking() → Firebase
/// 2. Buy pass: buyAndSetPass() → UserRepository.setActivePass() → Firebase
/// 3. Buy ticket: buySingleTicket() → PassRepository.createTicket() → UserRepository.setActivePass()
class RentingViewModel extends ChangeNotifier {
  final Station? _station;
  final RentingRepository _bookingRepository;
  final UserRepository _userRepository;
  final PassRepository _passRepository;

  User _user = const User(id: 'user_001', activePass: null);
  bool _isLoadingUser = true;
  String? _error;

  RentingViewModel({
    Station? station,
    required RentingRepository bookingRepository,
    required UserRepository userRepository,
    required PassRepository passRepository,
  }) : _station = station,
       _bookingRepository = bookingRepository,
       _userRepository = userRepository,
       _passRepository = passRepository {
    _initializeUser();
  }

  Station? get station => _station;
  User get user => _user;

  bool get isLoadingUser => _isLoadingUser;
  String? get error => _error;

  /// Check if user has an active pass
  bool get hasActivePass => _user.activePass != null;

  /// Get active pass details
  String? get activePassType => _user.activePass?.type.name.replaceFirst(
    _user.activePass!.type.name[0],
    _user.activePass!.type.name[0].toUpperCase(),
  );

  String? get activePassEndDate =>
      _user.activePass?.endDate.toString().split(' ')[0];

  /// Initialize user from Firebase on startup
  Future<void> _initializeUser() async {
    try {
      _isLoadingUser = true;
      notifyListeners();

      final currentUser = await _userRepository.getCurrentUser();
      _user = currentUser;
      _error = null;
    } catch (e) {
      _error = 'Failed to load user: $e';
      debugPrint('Error loading user: $e');
      // Use default user on error
      _user = const User(id: 'user_001', activePass: null);
    } finally {
      _isLoadingUser = false;
      notifyListeners();
    }
  }

  /// Confirm booking by creating booking record in Firebase
  ///
  /// Steps:
  /// 1. Validate station is selected
  /// 2. Find first available bike at station
  /// 3. Call repository.createBooking() to save to Firebase /bookings.json
  /// 4. Returns when Firebase confirms booking creation
  Future<void> confirmRenting() async {
    if (_station == null) {
      throw Exception('No station selected for booking');
    }

    final bikeId = _station.availableBikes
        .firstWhere((bike) => bike != null, orElse: () => null)
        ?.id;

    if (bikeId == null) {
      throw Exception('No available bike found at the selected station');
    }

    await _bookingRepository.createRenting(
      bikeId: bikeId,
      stationId: _station.id,
    );

    debugPrint(
      'Booking confirmed for station: ${_station.name} with pass: $activePassType',
    );
  }

  /// Purchase a pass and set as active user pass in Firebase
  ///
  /// Flow:
  /// 1. Call UserRepository.setActivePass() to save to Firebase
  /// 2. Update local user state
  /// 3. Notify UI listeners
  Future<void> buyAndSetPass(Pass passSelected) async {
    try {
      final updatedUser = await _userRepository.setActivePass(passSelected);
      _user = updatedUser;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to purchase pass: $e';
      debugPrint('Error buying pass: $e');
      rethrow;
    }
  }

  /// Purchase single ticket and set as active user pass in Firebase
  ///
  /// Flow:
  /// 1. Call PassRepository.createTicket() to create ticket in Firebase
  /// 2. Call UserRepository.setActivePass() to set ticket as active pass
  /// 3. Update local user state
  /// 4. Notify UI listeners
  Future<void> buySingleTicket() async {
    try {
      // Create temporary ticket in Firebase
      final ticket = await _passRepository.createTicket(
        userId: _user.id,
        type: PassType.day,
        price: 5.0,
      );

      // Set ticket as active pass in Firebase
      final updatedUser = await _userRepository.setActivePass(ticket);
      _user = updatedUser;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to purchase ticket: $e';
      debugPrint('Error buying ticket: $e');
      rethrow;
    }
  }

  /// Set user with a pass (used when returning from passes screen)
  /// After purchase, automatically updates local state and notifies listeners
  void updateUserWithPass(User userWithPass) {
    _user = userWithPass;
    _error = null;
    debugPrint(
      'User updated with new pass: ${userWithPass.activePass?.type.name}',
    );
    notifyListeners();
  }

  /// Refresh user data from Firebase
  /// Used to ensure latest user state after external updates
  Future<void> refreshUserData() async {
    try {
      _isLoadingUser = true;
      notifyListeners();

      final currentUser = await _userRepository.getCurrentUser();
      _user = currentUser;
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
