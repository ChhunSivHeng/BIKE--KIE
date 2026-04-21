import 'package:flutter/material.dart';
import '../../../../model/station.dart';
import '../../../../utils/app_theme.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong2.dart';
import 'package:provider/provider.dart';

import '../../../../ui/widgets/display/search_bar.dart';
import '../../../../utils/async_value.dart';
import '../view_model/map_view_model.dart';
import 'station_marker.dart';
import 'station_details_sheet.dart';
import 'search_results_sheet.dart';
import 'filter_dialog.dart';

/// Map screen main content - minimal and focused
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
                _mapController.move(LatLng(s.latitude!, s.longitude!), 17);
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

  void _showFilterDialog(MapViewModel vm) {
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
          vm.loadStations(
            minBike: minBikes,
            onlyShowAvailableBike: showOnlyAvailable,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MapViewModel>(
      builder: (context, vm, _) {
        if (vm.data.state == AsyncValueState.loading) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          );
        }

        if (vm.data.state == AsyncValueState.error) {
          final error = vm.data.error ?? 'Unknown error';
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.location_off,
                    size: 48,
                    color: AppColors.gray300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.gray600),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => vm.loadStations(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Try Again',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final data = vm.data.data ?? [];
        final markers = _buildStationMarkers(data);
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
                top: 16,
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
                    onTap: () => _showSearchSheet(data),
                    onFilterTap: () => _showFilterDialog(vm),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
