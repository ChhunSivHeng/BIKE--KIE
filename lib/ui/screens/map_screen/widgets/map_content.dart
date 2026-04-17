import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' show LatLng;
import 'package:provider/provider.dart';

import '../../../../model/station.dart';
import '../../../../ui/widgets/navigation/app_header.dart';
import '../../../../ui/widgets/navigation/bottom_nav_bar.dart';
import '../../../../ui/widgets/display/search_bar.dart';
import '../view_model/map_model.dart';
import '../states/station_state.dart';
import 'station_marker.dart';

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

  static final LatLng _phnomPenh = LatLng(11.5564, 104.9282);
  static const double _zoom = 14;

  static const double _mapTopPadding = AppHeader.height + 12 + 54 + 18;

  List<Marker> _buildStationMarkers(List<Station> stations) {
    return stations
        .map(
          (s) => Marker(
            point: LatLng(s.latitude!, s.longitude!),
            width: 44,
            height: 44,
            child: StationMarker(
              availableBikes: s.availableBikes,
              onTap: () {},
            ),
          ),
        )
        .toList(growable: false);
  }

  void _showSearchSheet(List<Station> allStations) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SearchResultsSheet(
        allStations: allStations,
        onStationSelected: (station) {
          Navigator.pop(context);
          _mapController.move(
            LatLng(station.latitude!, station.longitude!),
            17,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MapViewModel>();
    final state = vm.state;

    if (state.status == Status.loading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.status == Status.error) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  state.error ?? 'Something went wrong.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: vm.loadStations,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final markers = _buildStationMarkers(state.stations);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Base → flutter_map (OpenStreetMap)
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(
                top: _mapTopPadding,
                bottom: AppBottomNavBar.height,
              ),
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _phnomPenh,
                  initialZoom: _zoom,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    userAgentPackageName: 'com.example.bike_kie',
                  ),
                  MarkerLayer(markers: markers),
                ],
              ),
            ),
          ),

          // Top → app_header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppHeader(onMenuTap: () {}),
          ),

          // Floating → search_bar
          Positioned(
            top: AppHeader.height + 12,
            left: 16,
            right: 16,
            child: AppSearchBar(
              onTap: () => _showSearchSheet(state.stations),
              onFilterTap: () {},
            ),
          ),

          // Current location indicator (overlay)
          Positioned(
            left: 0,
            right: 0,
            top: _mapTopPadding,
            bottom: AppBottomNavBar.height,
            child: IgnorePointer(
              child: Center(
                child: Transform.translate(
                  offset: const Offset(34, 18),
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E88E5),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x22000000),
                          blurRadius: 10,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom → bottom_nav_bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AppBottomNavBar(
              activeTab: BottomNavTab.map,
              onTabSelected: (_) {},
            ),
          ),
        ],
      ),
    );
  }
}

class SearchResultsSheet extends StatefulWidget {
  final List<Station> allStations;
  final Function(Station) onStationSelected;

  const SearchResultsSheet({
    super.key,
    required this.allStations,
    required this.onStationSelected,
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
      if (query.isEmpty) {
        _filteredStations = widget.allStations;
      } else {
        _filteredStations = widget.allStations
            .where((s) => s.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Search input
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                onChanged: _updateSearch,
                decoration: InputDecoration(
                  hintText: 'Search stations...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _updateSearch('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                ),
              ),
            ),
            // Results list
            Expanded(
              child: _filteredStations.isEmpty
                  ? Center(
                      child: Text(
                        _searchController.text.isEmpty
                            ? 'No stations available'
                            : 'No stations found',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: _filteredStations.length,
                      itemBuilder: (context, index) {
                        final station = _filteredStations[index];
                        return ListTile(
                          title: Text(station.name),
                          subtitle: Row(
                            children: [
                              const Icon(
                                Icons.two_wheeler,
                                size: 16,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${station.availableBikes} bikes',
                                style: const TextStyle(color: Colors.green),
                              ),
                              const SizedBox(width: 12),
                              const Icon(
                                Icons.local_parking,
                                size: 16,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${station.totalSlots - station.availableBikes} slots',
                                style: const TextStyle(color: Colors.orange),
                              ),
                            ],
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.black54,
                          ),
                          onTap: () => widget.onStationSelected(station),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
