import 'package:bikkie/ui/screens/renting_screen/widgets/renting_actions_section.dart';
import 'package:bikkie/ui/screens/renting_screen/widgets/renting_pass_selection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/user.dart';
import '../../../../utils/animations_util.dart';
import '../../../../utils/app_theme.dart';
import '../../../widgets/map_preview.dart';
import '../../../widgets/renting_header.dart';
import '../../../widgets/station_info_card.dart';
import '../../map_screen/view_model/map_view_model.dart';
import '../../pass_screen/pass_screen.dart';
import '../../success_screen/success_screen.dart';
import '../view_model/renting_model.dart';
import 'payment_dialog.dart';
import 'renting_bike_section.dart';

class _Texts {
  static const screenTitle = 'Station Details';
  static const titleHasBike = 'Bike Assigned!';
  static const subtitleHasBike = 'Your bike is ready for your ride';
  static const titleConfirm = 'Confirm Your Renting';
  static const subtitleConfirm = 'Ready for your ride across Phnom Penh?';
  static const titleNoPass = 'Get a Pass to Rent';
  static const subtitleNoPass = 'Choose how you want to ride';
}

class RentingContent extends StatefulWidget {
  const RentingContent({super.key});

  @override
  State<RentingContent> createState() => _RentingContentState();
}

class _RentingContentState extends State<RentingContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
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

  Future<void> _handleConfirmRenting() async {
    final vm = context.read<RentingViewModel>();
    try {
      final renting = await vm.confirmRenting();

      if (!mounted) return;

      context.read<MapViewModel>().refreshAfterRenting(renting, vm.user);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SuccessScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Renting failed: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  void _handleBrowsePasses() {
    final vm = context.read<RentingViewModel>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(appBar: AppBar(), body: PassScreen()),
      ),
    ).then((result) {
      if (result is User && mounted) {
        vm.updateUserWithPass(result);
      }
    });
  }

  void _handleBuyTicket() {
    final vm = context.read<RentingViewModel>();
    showDialog(
      context: context,
      builder: (_) => PaymentDialog(
        onConfirm: () async {
          await vm.buySingleTicket();
        },
        onCancel: () {},
      ),
    );
  }

  void _handleViewTimer() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RentingViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(_Texts.screenTitle),
        centerTitle: true,
      ),
      body: _buildBody(vm),
    );
  }

  Widget _buildBody(RentingViewModel vm) {
    if (vm.station == null) {
      return const Center(child: Text('No station selected'));
    }

    final headerTitle = vm.hasActiveBike
        ? _Texts.titleHasBike
        : vm.hasActivePass
        ? _Texts.titleConfirm
        : _Texts.titleNoPass;

    final headerSubtitle = vm.hasActiveBike
        ? _Texts.subtitleHasBike
        : vm.hasActivePass
        ? _Texts.subtitleConfirm
        : _Texts.subtitleNoPass;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: RentingHeader(
                title: headerTitle,
                subtitle: headerSubtitle,
              ),
            ),
            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MapPreview(
                latitude: vm.station!.latitude,
                longitude: vm.station!.longitude,
                badgeLabel: vm.station!.name,
              ),
            ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: StationInfoCard(station: vm.station!),
            ),
            const SizedBox(height: 20),
            RentingPassSection(
              hasActivePass: vm.hasActivePass,
              passType: vm.activePassType,
              passEndDate: vm.activePassEndDate,
            ),
            const SizedBox(height: 16),
            RentingBikeSection(
              bikeId: vm.activeBikeId,
              batteryLevel: vm.activeBikeRange,
            ),
            const SizedBox(height: 24),
            RentingActionSection(
              hasActiveBike: vm.hasActiveBike,
              hasActivePass: vm.hasActivePass,
              onConfirm: _handleConfirmRenting,
              onBrowsePasses: _handleBrowsePasses,
              onBuyTicket: _handleBuyTicket,
              onViewTimer: _handleViewTimer,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
