import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../model/station.dart';
import '../../../../utils/app_theme.dart';
import '../../../widgets/display/app_button.dart';
import '../../../widgets/display/alert_card.dart';
import '../state/booking_content_state.dart';
import '../view_model/booking_model.dart';

/// Booking screen text constants
class _BookingTexts {
  static const String screenTitle = 'Stations Details';
  static const String headerTitle = 'Confirm Your Booking';
  static const String headerSubtitle = 'Ready for your ride across Toulouse?';
  static const String activeSubscription = 'ACTIVE SUBSCRIPTION';
  static const String noActivePass = 'No Active Pass';
  static const String noPassWarning =
      'You need a pass to book. Choose an option below.';
  static const String confirmBooking = 'CONFIRM BOOKING';
}

/// Spacing and sizing constants for booking content layout
const double _kPaddingLarge = 16;
const double _kPaddingMedium = 12;
const double _kSpacingSmall = 4;
const double _kSpacingMedium = 8;
const double _kSpacingLarge = 12;
const double _kSpacingXLarge = 20;
const double _kSpacingXXLarge = 24;
const double _kRadiusLarge = 12;
const double _kButtonHeight = 52;
const double _kMapHeight = 160;

/// Get location text with sector and availability
String _getLocationText(int availableBikes) {
  return 'Sector 1 • $availableBikes bikes available';
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
class BookingContent extends StatefulWidget {
  const BookingContent({super.key});

  @override
  State<BookingContent> createState() => _BookingContentState();
}

class _BookingContentState extends State<BookingContent>
    with SingleTickerProviderStateMixin, BookingContentStateMixin {
  @override
  void initState() {
    super.initState();
    initBookingState();
  }

  @override
  void dispose() {
    disposeBookingState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BookingViewModel>();
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
        title: const Text(_BookingTexts.screenTitle),
        centerTitle: true,
      ),
      body: _buildContent(vm, theme),
    );
  }

  Widget _buildContent(BookingViewModel vm, ThemeData theme) {
    final station = vm.station;

    if (station == null) {
      return const Center(child: Text('No station selected'));
    }

    return FadeTransition(
      opacity: fadeAnimation,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(_kPaddingLarge),
              child: _buildHeader(theme),
            ),
            const SizedBox(height: _kSpacingMedium),
            _buildMapPreview(),
            const SizedBox(height: _kSpacingXLarge),
            _buildStationCard(station, theme),
            const SizedBox(height: _kSpacingXLarge),
            _buildPassSection(vm, theme),
            const SizedBox(height: _kSpacingXXLarge),
            _buildActionSection(vm),
            const SizedBox(height: _kSpacingXLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          _BookingTexts.headerTitle,
          style: TextStyle(
            color: AppColors.black,
            fontSize: 32,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _BookingTexts.headerSubtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.gray600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMapPreview() {
    return Container(
      height: _kMapHeight,
      margin: const EdgeInsets.symmetric(horizontal: _kPaddingLarge),
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(_kRadiusLarge),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.map, size: 48, color: AppColors.gray400),
          Positioned(
            bottom: _kPaddingMedium,
            left: _kPaddingMedium,
            child: _buildMapPlaceholderBadge(),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholderBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: _kPaddingMedium,
        vertical: _kSpacingSmall,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(_kRadiusLarge),
        border: Border.all(color: AppColors.gray200),
      ),
      child: const Text(
        'Map Preview',
        style: TextStyle(
          color: AppColors.black,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStationCard(Station station, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _kPaddingLarge),
      child: Container(
        padding: const EdgeInsets.all(_kPaddingMedium),
        decoration: BoxDecoration(
          color: AppColors.gray50,
          borderRadius: BorderRadius.circular(_kRadiusLarge),
          border: Border.all(color: AppColors.gray200),
        ),
        child: Row(
          children: [
            _buildLocationBadge(),
            const SizedBox(width: _kSpacingLarge),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    station.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: _kSpacingSmall),
                  Text(
                    _getLocationText(station.bikeAmounts),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.gray600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationBadge() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(_kRadiusLarge),
        border: Border.all(color: AppColors.gray200),
      ),
      child: const Center(
        child: Icon(Icons.location_on, color: AppColors.primary, size: 22),
      ),
    );
  }

  Widget _buildPassSection(BookingViewModel vm, ThemeData theme) {
    if (!vm.hasActivePass) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: _kPaddingLarge),
        child: AlertCard(
          title: _BookingTexts.noActivePass,
          message: _BookingTexts.noPassWarning,
          backgroundColor: const Color(0xFFFFF3E0),
          borderColor: const Color(0xFFFFD54F),
          textColor: const Color(0xFFF57C00),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _kPaddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            _BookingTexts.activeSubscription,
            style: TextStyle(
              color: AppColors.gray600,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: _kSpacingMedium),
          _buildPassInfoCard(
            vm.activePassType ?? 'Unknown Pass',
            vm.activePassEndDate ?? 'N/A',
            theme,
          ),
        ],
      ),
    );
  }

  Widget _buildPassInfoCard(
    String passTypeName,
    String validUntil,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(_kPaddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_kRadiusLarge),
        border: Border.all(color: AppColors.primary),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            passTypeName,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: _kSpacingMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPassDetailItem(
                label: 'Valid Until',
                value: validUntil,
                theme: theme,
              ),
              _buildPassDetailItem(
                label: 'Booking Fee',
                value: 'INCLUDED',
                theme: theme,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPassDetailItem({
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.gray600,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: _kSpacingSmall),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildActionSection(BookingViewModel vm) {
    return vm.hasActivePass
        ? _buildConfirmButton()
        : _buildPassSelectionButtons();
  }

  Widget _buildConfirmButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _kPaddingLarge),
      child: AppButton(
        label: _BookingTexts.confirmBooking,
        onPressed: handleConfirmBooking,
        height: _kButtonHeight,
        borderRadius: _kRadiusLarge,
      ),
    );
  }

  Widget _buildPassSelectionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _kPaddingLarge),
      child: Row(
        children: [
          Expanded(
            child: AppButton(
              label: 'BROWSE PASSES',
              onPressed: handleBrowsePasses,
              outlined: true,
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
              foregroundColor: AppColors.primary,
              height: _kButtonHeight,
              borderRadius: _kRadiusLarge,
            ),
          ),
          const SizedBox(width: _kSpacingLarge),
          Expanded(
            child: AppButton(
              label: 'BUY TICKET',
              onPressed: handleBuyTicket,
              height: _kButtonHeight,
              borderRadius: _kRadiusLarge,
            ),
          ),
        ],
      ),
    );
  }
}
