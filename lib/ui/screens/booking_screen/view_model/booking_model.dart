import 'package:flutter/foundation.dart';
import '../../../../model/pass.dart';
import '../../../../model/station.dart';
import '../../../../model/user.dart';

class BookingViewModel extends ChangeNotifier {
  final Station? _station;
  User _user = const User(id: 'user_001', activePass: null); // Mock user

  BookingViewModel({Station? station}) : _station = station;

  Station? get station => _station;
  User get user => _user;

  /// Check if user has an active pass
  bool get hasActivePass => _user.activePass != null;

  /// Get active pass details
  String? get activePassType => _user.activePass?.type.name.replaceFirst(
    _user.activePass!.type.name[0],
    _user.activePass!.type.name[0].toUpperCase(),
  );

  String? get activePassEndDate =>
      _user.activePass?.endDate.toString().split(' ')[0];

  /// Confirm booking with current pass
  void confirmBooking() {
    // TODO: Call API to confirm booking
    // TODO: Update station availability
    debugPrint(
      'Booking confirmed for station: ${_station?.name} with pass: $activePassType',
    );
  }

  /// Simulate buying a pass after browsing
  void buyAndSetPass(Pass passSelected) {
    _user = User(id: _user.id, activePass: passSelected);
    notifyListeners();
  }

  /// Simulate buying single ticket
  void buySingleTicket() {
    // Create a temporary single-use pass
    final singlePass = Pass(
      id: 'ticket_${DateTime.now().millisecondsSinceEpoch}',
      type: PassType.day,
      price: 5.0,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 1)),
      isActive: true,
    );
    _user = User(id: _user.id, activePass: singlePass);
    notifyListeners();
  }

  /// Set user with a pass after purchase
  void setUserWithPass(User userWithPass) {
    _user = userWithPass;
    notifyListeners();
  }
}
