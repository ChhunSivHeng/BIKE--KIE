import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' show LatLng;
import 'package:provider/provider.dart';

import '../../widgets/app_header.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/search_bar.dart';
import 'map_view_model.dart';
import 'states/station_state.dart';
import 'widgets/station_marker.dart';

class MapContent extends StatelessWidget {
  const MapContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MapViewModel>(
      create: (_) => MapViewModel()..loadStations(),
      child: const _MapView(),
    );
  }
}

class _MapView extends StatelessWidget {
  const _MapView();

  static final LatLng _phnomPenh = LatLng(11.5564, 104.9282);
  static const double _zoom = 14;

  static const double _mapTopPadding = AppHeader.height + 12 + 54 + 18;

  List<Marker> _buildStationMarkers(List<Station> stations) {
    return stations
        .map(
          (s) => Marker(
            point: LatLng(s.latitude, s.longitude),
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
                options: MapOptions(
                  // If your flutter_map version uses (center/zoom), rename these accordingly.
                  initialCenter: _phnomPenh,
                  initialZoom: _zoom,
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
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
              onTap: () {},
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
                        )
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

// No changes required: UI -> ViewModel -> Repository -> Mock Data Source