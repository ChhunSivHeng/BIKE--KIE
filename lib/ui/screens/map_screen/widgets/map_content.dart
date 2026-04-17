import 'package:flutter/material.dart';
import '../../../../model/station.dart';
import '../../../../utils/app_theme.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' show LatLng;
import 'package:provider/provider.dart';

import '../../../../ui/widgets/navigation/app_header.dart';
import '../../../../ui/widgets/display/search_bar.dart';
import '../../../../utils/async_value.dart';
import '../view_model/map_view_model.dart';
import 'station_marker.dart';
import 'station_details_sheet.dart';

class MapContent extends StatelessWidget {
  const MapContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MapView();
  }
}

class _MapView extends StatefulWidget {
  const _MapView();

  @override
  State<_MapView> createState() => _MapViewState();
}

class _MapViewState extends State<_MapView> {
  final MapController _mapController = MapController();

  int _minBikes = 0;
  bool _showOnlyAvailable = false;

  static final LatLng _phnomPenh = LatLng(11.5564, 104.9282);
  static const double _zoom = 14;

  List<Marker> _buildStationMarkers(List<Station> stations) {
    return stations
        .map(
          (s) => Marker(
            point: LatLng(s.latitude!, s.longitude!),
            width: 44,
            height: 44,
            child: StationMarker(
              availableBikes: s.bikeAmounts,
              onTap: () {
                _showStationDetails(stations, s);
              },
            ),
          ),
        )
        .toList(growable: false);
  }

  void _showStationDetails(List<Station> allStations, Station station) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StationDetailsSheet(
        initialStation: station,
        allStations: allStations,
        onStationChanged: (newStation) {
          // Center map on new station
          _mapController.move(
            LatLng(newStation.latitude!, newStation.longitude!),
            17,
          );
        },
      ),
    );
  }

  void _showSearchSheet(List<Station> allStations) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SearchResultsSheet(
        allStations: allStations,
        minBikes: _minBikes,
        showOnlyAvailable: _showOnlyAvailable,
        onStationSelected: (station) {
          Navigator.pop(context);
          _showStationDetails(allStations, station);
        },
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => FilterDialog(
        initialMinBikes: _minBikes,
        initialShowOnlyAvailable: _showOnlyAvailable,
        onApply: (minBikes, showOnlyAvailable) {
          setState(() {
            _minBikes = minBikes;
            _showOnlyAvailable = showOnlyAvailable;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MapViewModel>();
    AsyncValue<List<Station>> data = vm.data;

    if (data.state == AsyncValueState.loading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Loading stations...',
                style: TextStyle(
                  color: AppColors.gray700,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (data.state == AsyncValueState.error) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.error_outline,
                    color: AppColors.error,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  data.error.toString().isEmpty ? 'Something went wrong.' : data.error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.gray700,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: vm.loadStations,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: const Text(
                    'Try Again',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final markers = _buildStationMarkers(data.data!);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _phnomPenh,
                initialZoom: _zoom,
                maxZoom: 19,
                minZoom: 11,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c', 'd'],
                  userAgentPackageName: 'com.example.bike_kie',
                  maxZoom: 20,
                ),
                  MarkerLayer(markers: markers),
                ],
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppHeader(onMenuTap: () {}),
          ),

          Positioned(
            top: AppHeader.height + 10,
            left: 12,
            right: 12,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: AppSearchBar(
                onTap: () => _showSearchSheet(data.data!),
                onFilterTap: _showFilterDialog,
              ),
            ),
          ),

        ],
      ),
    );
  }
}

class SearchResultsSheet extends StatefulWidget {
  final List<Station> allStations;
  final int minBikes;
  final bool showOnlyAvailable;
  final Function(Station) onStationSelected;

  const SearchResultsSheet({
    super.key,
    required this.allStations,
    required this.onStationSelected,
    this.minBikes = 0,
    this.showOnlyAvailable = false,
  });

  @override
  State<SearchResultsSheet> createState() => _SearchResultsSheetState();
}

class _SearchResultsSheetState extends State<SearchResultsSheet> {
  late TextEditingController _searchController;
  late List<Station> _filteredStations;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredStations = widget.allStations;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateSearch(String query) {
    setState(() {
      var results = widget.allStations;

      if (query.isNotEmpty) {
        results = results
            .where((s) => s.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }

      if (widget.minBikes > 0) {
        results = results
            .where((s) => s.bikeAmounts >= widget.minBikes)
            .toList();
      }

      if (widget.showOnlyAvailable) {
        results = results.where((s) => s.bikeAmounts > 0).toList();
      }

      _filteredStations = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.95,
      minChildSize: 0.3,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.08),
                blurRadius: 20,
                spreadRadius: -2,
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.gray200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: TextField(
                  controller: _searchController,
                  onChanged: _updateSearch,
                  decoration: InputDecoration(
                    hintText: 'Search stations...',
                    hintStyle: const TextStyle(
                      color: AppColors.gray400,
                      fontSize: 15,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: AppColors.primary,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              _updateSearch('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      borderSide: const BorderSide(
                        color: AppColors.gray100,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      borderSide: const BorderSide(
                        color: AppColors.gray100,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                      horizontal: AppSpacing.lg,
                    ),
                    filled: true,
                    fillColor: AppColors.gray50,
                  ),
                  style: const TextStyle(color: AppColors.black, fontSize: 15),
                ),
              ),
              Expanded(
                child: _filteredStations.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _searchController.text.isEmpty
                                  ? Icons.location_city
                                  : Icons.search_off,
                              size: 48,
                              color: const Color(0xFFCBD5E1),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _searchController.text.isEmpty
                                  ? 'No stations available'
                                  : 'No stations found',
                              style: const TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 12,
                        ),
                        itemCount: _filteredStations.length,
                        itemBuilder: (context, index) {
                          final station = _filteredStations[index];
                          final availableSlots =
                              station.totalSlots - station.bikeAmounts;
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 8,
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => widget.onStationSelected(station),
                                borderRadius: BorderRadius.circular(14),
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: AppColors.gray100,
                                      width: 1.2,
                                    ),
                                    color: AppColors.gray50,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.black.withOpacity(
                                          0.02,
                                        ),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              station.name,
                                              style: const TextStyle(
                                                color: AppColors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 12,
                                            color: AppColors.gray400,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: AppSpacing.lg,
                                              vertical: AppSpacing.sm,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    AppRadius.sm,
                                                  ),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.pedal_bike,
                                                  size: 14,
                                                  color: AppColors.primary,
                                                ),
                                                const SizedBox(
                                                  width: AppSpacing.xs,
                                                ),
                                                Text(
                                                  '${station.bikeAmounts}',
                                                  style: const TextStyle(
                                                    color: AppColors.primary,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: AppSpacing.md),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: AppSpacing.lg,
                                              vertical: AppSpacing.sm,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    AppRadius.sm,
                                                  ),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.local_parking,
                                                  size: 14,
                                                  color: AppColors.primary,
                                                ),
                                                const SizedBox(
                                                  width: AppSpacing.xs,
                                                ),
                                                Text(
                                                  '$availableSlots',
                                                  style: const TextStyle(
                                                    color: AppColors.primary,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class FilterDialog extends StatefulWidget {
  final int initialMinBikes;
  final bool initialShowOnlyAvailable;
  final Function(int, bool) onApply;

  const FilterDialog({
    super.key,
    required this.initialMinBikes,
    required this.initialShowOnlyAvailable,
    required this.onApply,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late int _minBikes;
  late bool _showOnlyAvailable;

  @override
  void initState() {
    super.initState();
    _minBikes = widget.initialMinBikes;
    _showOnlyAvailable = widget.initialShowOnlyAvailable;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 12,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.15),
              blurRadius: 24,
              spreadRadius: -4,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filter Stations',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.gray100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.close_rounded,
                        color: AppColors.gray600,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Text(
                'Minimum Available Bikes',
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.gray50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.gray100, width: 1.2),
                ),
                child: Column(
                  children: [
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: const Color(0xFFC41E3A),
                        inactiveTrackColor: const Color(0xFFE2E8F0),
                        thumbColor: const Color(0xFFC41E3A),
                        overlayColor: const Color(0xFFC41E3A).withOpacity(0.2),
                        trackHeight: 6,
                        thumbShape: const RoundSliderThumbShape(
                          elevation: 0,
                          enabledThumbRadius: 10,
                        ),
                      ),
                      child: Slider(
                        value: _minBikes.toDouble(),
                        min: 0,
                        max: 20,
                        divisions: 20,
                        label: '$_minBikes bikes',
                        onChanged: (value) {
                          setState(() {
                            _minBikes = value.toInt();
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Showing stations with $_minBikes or more bikes',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _showOnlyAvailable
                      ? AppColors.primary.withOpacity(0.08)
                      : AppColors.gray50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _showOnlyAvailable
                        ? AppColors.primary.withOpacity(0.4)
                        : AppColors.gray100,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Transform.scale(
                      scale: 1.3,
                      child: Checkbox(
                        value: _showOnlyAvailable,
                        onChanged: (value) {
                          setState(() {
                            _showOnlyAvailable = value ?? false;
                          });
                        },
                        activeColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Show only available stations',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Stations with at least one bike',
                            style: TextStyle(
                              color: AppColors.gray500,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: BorderSide(
                          color: AppColors.primary.withOpacity(0.4),
                          width: 1.5,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          widget.onApply(_minBikes, _showOnlyAvailable),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Apply Filters',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
