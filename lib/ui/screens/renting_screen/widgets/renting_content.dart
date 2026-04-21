import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/app_theme.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/display/alert_card.dart';
import '../../../widgets/renting_header.dart';
import '../../../widgets/map_preview.dart';
import '../../../widgets/pass_info_card.dart';
import '../../../widgets/station_info_card.dart';
import '../state/renting_content_state.dart';
import '../view_model/renting_model.dart';

/// Booking screen text constants
class _RentingTexts {
  static const String screenTitle = 'Stations Details';
  static const String headerTitleConfirm = 'Confirm Your Renting';
  static const String headerSubtitleConfirm =
      'Ready for your ride across Toulouse?';
  static const String headerTitleNoPass = 'Get a Pass to Rent';
  static const String headerSubtitleNoPass = 'Choose how you want to ride';
}

/// Booking confirmation screen content
///
/// Displays:
/// 1. Station map preview
/// 2. Station details (name, bikes available)
/// 3. Pass status (active pass or "no pass" warning)
/// 4. Action buttons (Confirm / Browse Passes / Buy Ticket)
///
/// State management:
/// - Watches BookingViewModel for user state changes
/// - Uses BookingContentStateMixin for animation & action handlers
/// - Responds to user interactions (confirm, browse, buy ticket)
class RentingContent extends StatefulWidget {
  const RentingContent({super.key});

  @override
  State<RentingContent> createState() => _RentingContentState();
}

class _RentingContentState extends State<RentingContent>
    with SingleTickerProviderStateMixin, RentingContentStateMixin {
  @override
  void initState() {
    super.initState();
    initRentingState();
  }

  @override
  void dispose() {
    disposeRentingState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RentingViewModel>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(_RentingTexts.screenTitle),
        centerTitle: true,
      ),
      body: _buildContent(vm, theme),
    );
  }

  Widget _buildContent(RentingViewModel vm, ThemeData theme) {
    final station = vm.station;

    if (station == null) {
      return const Center(child: Text('No station selected'));
    }

    final hasPass = vm.hasActivePass;

    return FadeTransition(
      opacity: fadeAnimation,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: RentingHeader(
                title: hasPass
                    ? _RentingTexts.headerTitleConfirm
                    : _RentingTexts.headerTitleNoPass,
                subtitle: hasPass
                    ? _RentingTexts.headerSubtitleConfirm
                    : _RentingTexts.headerSubtitleNoPass,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MapPreview(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: StationInfoCard(station: station),
            ),
            const SizedBox(height: 20),
            _buildPassSection(vm),
            const SizedBox(height: 24),
            _buildActionSection(vm),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPassSection(RentingViewModel vm) {
    if (!vm.hasActivePass) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: AlertCard(
          title: 'No Active Pass',
          message: 'You need a pass to rent. Choose an option below.',
          backgroundColor: const Color(0xFFFFF3E0),
          borderColor: const Color(0xFFFFD54F),
          textColor: const Color(0xFFF57C00),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ACTIVE SUBSCRIPTION',
            style: TextStyle(
              color: AppColors.gray600,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          PassInfoCard(
            passType: vm.activePassType ?? 'Unknown Pass',
            details: [
              PassDetailItem(
                label: 'Valid Until',
                value: vm.activePassEndDate ?? 'N/A',
              ),
              PassDetailItem(label: 'Renting Fee', value: 'INCLUDED'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionSection(RentingViewModel vm) {
    return vm.hasActivePass
        ? _buildConfirmButton()
        : _buildPassSelectionButtons();
  }

  Widget _buildConfirmButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AppButton(
        label: 'CONFIRM RENTING',
        onPressed: handleConfirmRenting,
        height: 52,
        borderRadius: 12,
      ),
    );
  }

  Widget _buildPassSelectionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: AppButton(
              label: 'BROWSE PASSES',
              onPressed: handleBrowsePasses,
              outlined: true,
              foregroundColor: AppColors.primary,
              height: 52,
              borderRadius: 12,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppButton(
              label: 'BUY TICKET',
              onPressed: handleBuyTicket,
              height: 52,
              borderRadius: 12,
            ),
          ),
        ],
      ),
    );
  }
}
