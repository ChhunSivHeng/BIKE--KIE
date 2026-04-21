import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/booking_model.dart';
import 'booking_actions.dart';
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
mixin BookingContentStateMixin<T extends StatefulWidget>
    on State<T>, SingleTickerProviderStateMixin<T> {
  late AnimationController bookingController;
  late Animation<double> fadeAnimation;

  /// Initialize animation controller and fade animation
  void initBookingState() {
    bookingController = AnimationController(
      duration: AnimationUtils.normal,
      vsync: this,
    );
    fadeAnimation = AnimationUtils.createFadeAnimation(bookingController);
    bookingController.forward();
  }

  /// Clean up animation controller
  void disposeBookingState() {
    bookingController.dispose();
  }

  /// Trigger UI rebuild
  void refreshBooking() => setState(() {});

  /// Handle confirm booking button → Firebase call → navigate
  void handleConfirmBooking() {
    BookingActions.handleConfirmBooking(
      context,
      context.read<BookingViewModel>(),
      refreshBooking,
    );
  }

  /// Handle browse passes button → navigate to passes screen
  /// Captures returned user if pass was purchased
  void handleBrowsePasses() {
    BookingActions.handleBrowsePasses(
      context,
      context.read<BookingViewModel>(),
      refreshBooking,
    );
  }

  /// Handle buy ticket button → show payment dialog → purchase ticket
  /// On successful purchase, refresh UI to show confirm booking
  void handleBuyTicket() {
    BookingActions.handleBuyTicket(context, refreshBooking);
  }
}
