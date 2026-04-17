import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/animations_util.dart';
import '../view_model/booking_model.dart';
import 'booking_appbar.dart';
import 'booking_body.dart';
import 'booking_actions.dart';

class BookingContent extends StatefulWidget {
  const BookingContent({super.key});

  @override
  State<BookingContent> createState() => _BookingContentState();
}

class _BookingContentState extends State<BookingContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  void _setupAnimation() {
    _controller = AnimationController(
      duration: AnimationUtils.normal,
      vsync: this,
    );
    _fadeAnimation = AnimationUtils.createFadeAnimation(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BookingViewModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const BookingAppBar(),
      body: _buildContent(vm),
    );
  }

  Widget _buildContent(BookingViewModel vm) {
    final station = vm.station;

    if (station == null) {
      return const Center(child: Text('No station selected'));
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: BookingBody(
        station: station,
        viewModel: vm,
        onBrowsePasses: _onBrowsePasses,
        onBuyTicket: _onBuyTicket,
        onConfirmBooking: _onConfirmBooking,
      ),
    );
  }

  void _refresh() => setState(() {});

  void _onConfirmBooking() {
    // context.read (W5): One-time access for method calls (no subscription needed)
    BookingActions.handleConfirmBooking(
      context,
      context.read<BookingViewModel>(),
      _refresh,
    );
  }

  void _onBrowsePasses() {
    BookingActions.handleBrowsePasses(context, _refresh);
  }

  void _onBuyTicket() {
    BookingActions.handleBuyTicket(context);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _refresh();
    });
  }
}
