import 'dart:async';
import 'package:flutter/material.dart';

class Pick extends StatefulWidget {
  final String stationName;
  final DateTime expiryTime;

  final Future<bool> Function() onConfirmPickup;
  final Future<void> Function() onExpired;
  final Future<void> Function() onCancel;
  final String? unlockPin;

  const Pick({
    super.key,
    required this.stationName,
    required this.expiryTime,
    required this.onConfirmPickup,
    required this.onExpired,
    required this.onCancel,
    this.unlockPin,
  });

  @override
  State<Pick> createState() => _PickState();
}

enum _PickupState { countdown, arrived, success, expired }

class _PickState extends State<Pick> with TickerProviderStateMixin {
  Timer? _timer;
  int _remainingSeconds = 0;
  _PickupState _phase = _PickupState.countdown;
  bool _showPin = false;
  bool _loading = false;

  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  late AnimationController _successCtrl;
  late Animation<double> _successScale;
  late Animation<double> _successFade;

  static const _red = Color(0xFFD32F2F);
  static const _lightRed = Color(0xFFFFEBEE);
  static const _green = Color(0xFF2E7D32);
  static const _lightGreen = Color(0xFFE8F5E9);

  @override
  void initState() {
    super.initState();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(
      begin: 1.0,
      end: 1.06,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _successCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _successScale =
        CurvedAnimation(parent: _successCtrl, curve: Curves.elasticOut)
            as Animation<double>;
    _successFade =
        CurvedAnimation(parent: _successCtrl, curve: Curves.easeIn)
            as Animation<double>;

    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _updateRemaining() {
    final diff = widget.expiryTime.difference(DateTime.now()).inSeconds;
    _remainingSeconds = diff.clamp(0, 86400);
  }

  void _tick() {
    if (!mounted) return;
    setState(() {
      _updateRemaining();
      if (_remainingSeconds <= 0 && _phase == _PickupState.countdown) {
        _phase = _PickupState.expired;
        _timer?.cancel();
        widget.onExpired();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseCtrl.dispose();
    _successCtrl.dispose();
    super.dispose();
  }

  String get _timerText {
    final m = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  double get _progress {
    final total = widget.expiryTime
        .difference(
          DateTime.now().subtract(Duration(seconds: _remainingSeconds)),
        )
        .inSeconds;
    if (total <= 0) return 0;
    return (_remainingSeconds / total).clamp(0.0, 1.0);
  }

  Future<void> _handleUnlock() async {
    setState(() => _loading = true);
    final success = await widget.onConfirmPickup();
    if (!mounted) return;

    if (success) {
      _timer?.cancel();
      setState(() {
        _loading = false;
        _phase = _PickupState.success;
      });
      _successCtrl.forward();
    } else {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Could not confirm pickup. Please try again.'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 80),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Future<void> _handleCancel() async {
    setState(() => _loading = true);
    await widget.onCancel();
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 16)],
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, anim) =>
                FadeTransition(opacity: anim, child: child),
            child: switch (_phase) {
              _PickupState.countdown => _buildCountdown(),
              _PickupState.arrived => _buildArrived(),
              _PickupState.success => _buildSuccess(),
              _PickupState.expired => _buildExpired(),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCountdown() {
    return Column(
      key: const ValueKey('countdown'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _lightRed,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.directions_bike, color: _red, size: 22),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bike Reserved!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Pick up at ${widget.stationName}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 16),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: _lightRed,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Text(
                'Time remaining to pick up',
                style: TextStyle(
                  color: _red,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _timerText,
                style: const TextStyle(
                  color: _red,
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'MIN   ·   SEC',
                style: TextStyle(
                  color: _red.withOpacity(.6),
                  fontSize: 11,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _progress,
            minHeight: 5,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              _remainingSeconds < 120 ? Colors.orange : _red,
            ),
          ),
        ),

        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.info_outline, size: 13, color: Colors.grey),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                'Bike will be released automatically if not picked up.',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () => setState(() => _phase = _PickupState.arrived),
            icon: const Icon(Icons.location_on, size: 20),
            label: const Text(
              "I've Arrived",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
          ),
        ),

        const SizedBox(height: 10),

        SizedBox(
          width: double.infinity,
          height: 46,
          child: OutlinedButton.icon(
            onPressed: _loading ? null : _handleCancel,
            icon: _loading
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.close, size: 16),
            label: const Text('Cancel Reservation'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              side: BorderSide(color: Colors.grey[300]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildArrived() {
    return Column(
      key: const ValueKey('arrived'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: _lightGreen,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: _green, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "You're at the station!",
                      style: TextStyle(
                        color: _green,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Tap the button below to unlock your bike',
                      style: TextStyle(
                        color: _green.withOpacity(.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _lightRed,
            border: Border.all(color: _red.withOpacity(.2), width: 2),
          ),
          child: const Icon(Icons.directions_bike, color: _red, size: 42),
        ),
        const SizedBox(height: 8),
        Text(
          widget.stationName,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        Text(
          '$_timerText remaining',
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),

        const SizedBox(height: 24),

        ScaleTransition(
          scale: _pulseAnim,
          child: SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton.icon(
              onPressed: _loading ? null : _handleUnlock,
              icon: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.lock_open_rounded, size: 22),
              label: const Text(
                'Unlock Bike',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: _red.withOpacity(.4),
              ),
            ),
          ),
        ),

        const SizedBox(height: 14),

        if (widget.unlockPin != null) ...[
          GestureDetector(
            onTap: () => setState(() => _showPin = !_showPin),
            child: Text(
              _showPin
                  ? 'PIN: ${widget.unlockPin}  (tap to hide)'
                  : 'Having trouble? Tap to show PIN code',
              style: TextStyle(
                color: _red,
                fontSize: 13,
                decoration: TextDecoration.underline,
                decorationColor: _red,
              ),
            ),
          ),
          const SizedBox(height: 14),
        ],

        SizedBox(
          width: double.infinity,
          height: 44,
          child: OutlinedButton.icon(
            onPressed: _loading ? null : _handleCancel,
            icon: const Icon(Icons.close, size: 16),
            label: const Text('Cancel Reservation'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[600],
              side: BorderSide(color: Colors.grey[300]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccess() {
    return Column(
      key: const ValueKey('success'),
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),

        ScaleTransition(
          scale: _successScale,
          child: FadeTransition(
            opacity: _successFade,
            child: Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: _lightGreen,
              ),
              child: const Icon(Icons.check_rounded, color: _green, size: 54),
            ),
          ),
        ),

        const SizedBox(height: 16),

        const Text(
          'Ride Started!',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: _green,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Enjoy your ride from ${widget.stationName}',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),

        const SizedBox(height: 24),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _lightGreen,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _green.withOpacity(.2)),
          ),
          child: Row(
            children: [
              const Icon(Icons.directions_bike, color: _green, size: 28),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bike unlocked',
                    style: TextStyle(
                      color: _green,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    'Return to any station when done',
                    style: TextStyle(
                      color: _green.withOpacity(.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.amber.shade200),
          ),
          child: Row(
            children: [
              Icon(
                Icons.health_and_safety_outlined,
                color: Colors.amber.shade700,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Wear a helmet and follow traffic rules.',
                  style: TextStyle(color: Colors.amber.shade900, fontSize: 12),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildExpired() {
    return Column(
      key: const ValueKey('expired'),
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.timer_off_outlined, color: Colors.orange, size: 48),
        const SizedBox(height: 12),
        const Text(
          'Reservation Expired',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          'The bike has been released back to the station.\nYou can make a new reservation anytime.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.5),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _loading ? null : _handleCancel,
            style: ElevatedButton.styleFrom(
              backgroundColor: _red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: const Text(
              'OK, Got It',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }
}
