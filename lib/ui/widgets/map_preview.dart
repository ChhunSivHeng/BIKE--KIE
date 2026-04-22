import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../utils/app_theme.dart';

/// Reusable map preview component.
/// When [latitude] and [longitude] are provided it renders a real
/// interactive FlutterMap tile layer centred on that location with a pin.
/// Falls back to the old grey placeholder when no coordinates are given.
class MapPreview extends StatelessWidget {
  final double height;
  final double borderRadius;
  final double? latitude;
  final double? longitude;
  final String? badgeLabel;
  final VoidCallback? onTap;

  const MapPreview({
    super.key,
    this.height = 160,
    this.borderRadius = 12,
    this.latitude,
    this.longitude,
    this.badgeLabel = 'Map Preview',
    this.onTap,
  });

  bool get _hasCoords => latitude != null && longitude != null;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        height: height,
        child: _hasCoords ? _buildRealMap() : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildRealMap() {
    final center = LatLng(latitude!, longitude!);

    return GestureDetector(
      onTap: onTap,
      // AbsorbPointer prevents the map from consuming scroll/drag when
      // embedded in a ScrollView — it's view-only.
      child: AbsorbPointer(
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: center,
                initialZoom: 16,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.none, // fully static preview
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c', 'd'],
                  userAgentPackageName: 'com.example.bike_kie',
                  maxZoom: 20,
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: center,
                      width: 40,
                      height: 40,
                      child: const _StationPin(),
                    ),
                  ],
                ),
              ],
            ),

            // Optional badge
            if (badgeLabel != null)
              Positioned(
                bottom: 10,
                left: 10,
                child: _MapBadge(label: badgeLabel!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.gray100,
          border: Border.all(color: AppColors.gray200),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.map, size: 48, color: AppColors.gray400),
            if (badgeLabel != null)
              Positioned(
                bottom: 12,
                left: 12,
                child: _MapBadge(label: badgeLabel!),
              ),
          ],
        ),
      ),
    );
  }
}

/// Red pin shown on the preview map at the station location.
class _StationPin extends StatelessWidget {
  const _StationPin();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.directions_bike_rounded,
            color: Colors.white,
            size: 18,
          ),
        ),
        // Pin tail
        CustomPaint(size: const Size(10, 6), painter: _PinTailPainter()),
      ],
    );
  }
}

class _PinTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.primary;
    // final path = Path()
    //   ..moveTo(0, 0)
    //   ..lineTo(size.width / 2, size.height)
    //   ..lineTo(size.width, 0)
    //   ..close();
    // canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _MapBadge extends StatelessWidget {
  final String label;
  const _MapBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.black,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
