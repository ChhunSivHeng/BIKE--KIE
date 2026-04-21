import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/renting_model.dart';
import 'renting_actions.dart';
import '../../../../utils/animations_util.dart';

/// Mixin for managing booking screen state and animations
///
/// Provides:
/// - Animation controller for fade-in effect
/// - Action handler methods (confirm, browse, buy)
/// - State refresh callback
///
/// Used by: _BookingContentState
/// Separated to keep booking_content.dart focused on UI building
mixin RentingContentStateMixin<T extends StatefulWidget>
    on State<T>, SingleTickerProviderStateMixin<T> {
  late AnimationController rentingController;
  late Animation<double> fadeAnimation;

  /// Initialize animation controller and fade animation
  void initRentingState() {
    rentingController = AnimationController(
      duration: AnimationUtils.normal,
      vsync: this,
    );
    fadeAnimation = AnimationUtils.createFadeAnimation(rentingController);
    rentingController.forward();
  }

  /// Clean up animation controller
  void disposeRentingState() {
    rentingController.dispose();
  }

  /// Trigger UI rebuild
  void refreshRenting() => setState(() {});

  /// Handle confirm booking button → Firebase call → navigate
  void handleConfirmRenting() {
    RentingActions.handleConfirmRenting(
      context,
      context.read<RentingViewModel>(),
      refreshRenting,
    );
  }

  /// Handle browse passes button → navigate to passes screen
  /// Captures returned user if pass was purchased
  void handleBrowsePasses() {
    RentingActions.handleBrowsePasses(
      context,
      context.read<RentingViewModel>(),
      refreshRenting,
    );
  }

  /// Handle buy ticket button → show payment dialog → purchase ticket
  /// On successful purchase, refresh UI to show confirm booking
  void handleBuyTicket() {
    RentingActions.handleBuyTicket(context, refreshRenting);
  }
}
