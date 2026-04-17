import 'package:flutter/material.dart';
import '../../../../model/station.dart';
import '../view_model/booking_model.dart';
import 'booking_header.dart';
import 'map_preview_section.dart';
import 'station_card_widget.dart';
import 'active_pass_section.dart';
import 'no_pass_section.dart';
import 'pass_selection_buttons.dart';
import 'confirm_button.dart';
import 'booking_theme.dart';
import 'booking_constants.dart';

/// Main body content for booking screen
class BookingBody extends StatelessWidget {
  final Station station;
  final BookingViewModel viewModel;
  final VoidCallback onBrowsePasses;
  final VoidCallback onBuyTicket;
  final VoidCallback onConfirmBooking;

  const BookingBody({
    super.key,
    required this.station,
    required this.viewModel,
    required this.onBrowsePasses,
    required this.onBuyTicket,
    required this.onConfirmBooking,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildSections(),
      ),
    );
  }

  List<Widget> _buildSections() => [
    Padding(
      padding: const EdgeInsets.all(BookingTheme.paddingLarge),
      child: BookingHeader(
        title: BookingConstants.headerTitle,
        subtitle: BookingConstants.headerSubtitle,
      ),
    ),
    const SizedBox(height: BookingTheme.spacingMedium),
    const MapPreviewSection(),
    const SizedBox(height: BookingTheme.spacingXLarge),
    StationCardWidget(station: station),
    const SizedBox(height: BookingTheme.spacingXLarge),
    _buildPassSection(),
    const SizedBox(height: BookingTheme.spacingXXLarge),
    _buildActionSection(),
    const SizedBox(height: BookingTheme.spacingXLarge),
  ];

  Widget _buildPassSection() {
    if (!viewModel.hasActivePass) {
      return const NoPassSection();
    }

    return ActivePassSection(
      passTypeName: viewModel.activePassType ?? 'Unknown Pass',
      validUntil: viewModel.activePassEndDate ?? 'N/A',
    );
  }

  Widget _buildActionSection() {
    return viewModel.hasActivePass
        ? ConfirmButton(onPressed: onConfirmBooking)
        : PassSelectionButtons(
            viewModel: viewModel,
            onBrowsePasses: onBrowsePasses,
            onBuyTicket: onBuyTicket,
          );
  }
}
