import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../model/station.dart';
import '../../booking_screen/booking_screen.dart';
import '../view_model/station_details_model.dart';
import 'available_bikes_section.dart';
import 'booking_action_button.dart';
import 'nearby_stations_section.dart';
import 'station_info_card.dart';
import 'station_stats_section.dart';
import 'station_details_card.dart';
import 'sheet_components.dart';

class StationDetailsSheet extends StatefulWidget {
  final Station initialStation;
  final List<Station> allStations;
  final Function(Station) onStationChanged;

  const StationDetailsSheet({
    super.key,
    required this.initialStation,
    required this.allStations,
    required this.onStationChanged,
  });

  @override
  State<StationDetailsSheet> createState() => _StationDetailsSheetState();
}

class _StationDetailsSheetState extends State<StationDetailsSheet> {
  late StationDetailsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = StationDetailsViewModel(
      initialStation: widget.initialStation,
      allStations: widget.allStations,
      onStationChanged: widget.onStationChanged,
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _handleBookBike() {
    // Navigate to booking screen with the current station
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingScreen(station: _viewModel.currentStation),
      ),
    );
  }

  List<Widget> _buildContent(StationDetailsViewModel vm) => [
    StationDetailsCard(station: vm.currentStation),
    const SizedBox(height: 24),
    StationStatsSection(
      station: vm.currentStation,
      isLowAvailability: vm.isLowAvailability,
    ),
    const SizedBox(height: 24),
    AvailableBikesSection(
      station: vm.currentStation,
      onBookBike: _handleBookBike,
    ),
    const SizedBox(height: 20),
    BookingActionButton(
      hasAvailableBikes: vm.hasAvailableBikes,
      onBook: _handleBookBike,
    ),
    const SizedBox(height: 24),
    if (vm.getNearbyStations().isNotEmpty)
      NearbyStationsSection(
        currentStation: vm.currentStation,
        nearbyStations: vm.getNearbyStations(),
        onSelectStation: (s) => vm.switchStation(s),
      ),
    const SizedBox(height: 24),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StationDetailsViewModel>.value(
      value: _viewModel,
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) =>
            Consumer<StationDetailsViewModel>(
              builder: (context, vm, _) => SheetContainer(
                child: Column(
                  children: [
                    const DragHandle(),
                    StationInfoCard(
                      station: vm.currentStation,
                      isFavorite: vm.isFavorite,
                      onToggleFavorite: () => vm.toggleFavorite(),
                      onClose: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: _buildContent(vm),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
