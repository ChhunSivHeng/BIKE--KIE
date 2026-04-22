import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../model/bike.dart';
import '../../../../model/station.dart';
import '../../renting_screen/renting_screen.dart';
import '../view_model/station_details_model.dart';
import 'available_bikes_section.dart';
import 'renting_action_button.dart';
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

  void _navigateToRentingScreen({Bike? selectedBike, int? selectedSlotIndex}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RentingScreen(
          station: _viewModel.currentStation,
          selectedBike: selectedBike,
          selectedSlotIndex: selectedSlotIndex,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _viewModel = StationDetailsViewModel(
      initialStation: widget.initialStation,
      allStations: widget.allStations,
      onStationChanged: widget.onStationChanged,
      onRentRequested: ({selectedBike, selectedSlotIndex}) {
        _navigateToRentingScreen(
          selectedBike: selectedBike,
          selectedSlotIndex: selectedSlotIndex,
        );
      },
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  List<Widget> _buildContent(StationDetailsViewModel vm) => [
    StationDetailsCard(station: vm.currentStation),
    const SizedBox(height: 24),
    StationStatsSection(
      station: vm.currentStation,
      isLowAvailability: vm.isLowAvailability,
    ),
    const SizedBox(height: 24),
    // Each bike card passes its own bike + slotIndex
    AvailableBikesSection(
      station: vm.currentStation,
      onRentBike: (bike, slotIndex) =>
          vm.rentSelectedBike(bike: bike, slotIndex: slotIndex),
    ),
    const SizedBox(height: 20),
    // Bottom button rents any available bike (no specific selection)
    RentingActionButton(
      hasAvailableBikes: vm.hasAvailableBikes,
      onRent: () => vm.handleRentBike(),
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
