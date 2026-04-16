import 'package:flutter/material.dart';

class StationMarker extends StatelessWidget {
  const StationMarker({
    super.key,
    required this.availableBikes,
    this.onTap,
  });

  final int availableBikes;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hasBikes = availableBikes > 0;
    final borderColor = hasBikes ? const Color(0xFFE53935) : const Color(0xFFBDBDBD);
    final textColor = hasBikes ? const Color(0xFFE53935) : const Color(0xFF9E9E9E);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 2.5),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 10,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Text(
            availableBikes.toString().padLeft(2, '0'),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}