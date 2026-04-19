import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/booking_model.dart';
import 'booking_actions.dart';
import '../../../../utils/animations_util.dart';

mixin BookingContentStateMixin<T extends StatefulWidget>
    on State<T>, SingleTickerProviderStateMixin<T> {
  late AnimationController bookingController;
  late Animation<double> fadeAnimation;

  void initBookingState() {
    bookingController = AnimationController(
      duration: AnimationUtils.normal,
      vsync: this,
    );
    fadeAnimation = AnimationUtils.createFadeAnimation(bookingController);
    bookingController.forward();
  }

  void disposeBookingState() {
    bookingController.dispose();
  }

  void refreshBooking() => setState(() {});

  void handleConfirmBooking() {
    BookingActions.handleConfirmBooking(
      context,
      context.read<BookingViewModel>(),
      refreshBooking,
    );
  }

  void handleBrowsePasses() {
    BookingActions.handleBrowsePasses(context, refreshBooking);
  }

  void handleBuyTicket() {
    BookingActions.handleBuyTicket(context);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) refreshBooking();
    });
  }
}
