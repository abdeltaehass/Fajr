import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class QiblaCompass extends StatefulWidget {
  final double latitude;
  final double longitude;

  const QiblaCompass({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<QiblaCompass> createState() => _QiblaCompassState();
}

class _QiblaCompassState extends State<QiblaCompass>
    with SingleTickerProviderStateMixin {
  static const double _kaabaLat = 21.4225;
  static const double _kaabaLon = 39.8262;

  StreamSubscription<CompassEvent>? _compassSub;
  double _smoothedHeading = 0;
  double _targetHeading = 0;
  double? _accuracy;
  bool _hasData = false;
  late AnimationController _animController;

  // Low-pass filter coefficient (0 = no smoothing, 1 = infinite smoothing)
  static const double _smoothingFactor = 0.3;

  double get _qiblaDirection {
    final lat1 = widget.latitude * pi / 180;
    final lat2 = _kaabaLat * pi / 180;
    final dLon = (_kaabaLon - widget.longitude) * pi / 180;
    final x = sin(dLon) * cos(lat2);
    final y = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    return (atan2(x, y) * 180 / pi + 360) % 360;
  }

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        setState(() {});
      });
    _startCompass();
  }

  void _startCompass() {
    _compassSub = FlutterCompass.events?.listen((event) {
      final heading = event.heading;
      if (heading == null) return;

      _accuracy = event.accuracy;

      // Calculate shortest angular distance for smooth interpolation
      double delta = heading - _targetHeading;
      // Normalize delta to [-180, 180] so we always take the short way around
      while (delta > 180) {
        delta -= 360;
      }
      while (delta < -180) {
        delta += 360;
      }

      // Low-pass filter: blend new heading with previous to reduce jitter
      _targetHeading = _targetHeading + delta * (1 - _smoothingFactor);
      // Normalize to [0, 360)
      _targetHeading = (_targetHeading + 360) % 360;

      if (!_hasData) {
        // First reading — snap immediately
        _smoothedHeading = _targetHeading;
        _hasData = true;
        setState(() {});
      } else {
        // Animate from current to smoothed target
        _smoothedHeading = _targetHeading;
        if (!_animController.isAnimating) {
          _animController.forward(from: 0);
        }
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _compassSub?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final qibla = _qiblaDirection;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: IslamicColors.darkGreen,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: IslamicColors.gold.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.explore, color: IslamicColors.gold, size: 18),
              const SizedBox(width: 8),
              Text(
                'QIBLA DIRECTION',
                style: GoogleFonts.poppins(
                  color: IslamicColors.gold,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Compass
          _CompassDial(
            compassAngle: _hasData ? -_smoothedHeading * pi / 180 : 0,
            qiblaAngle: qibla * pi / 180,
            qiblaDegrees: qibla,
            isLive: _hasData,
            accuracy: _accuracy,
          ),
        ],
      ),
    );
  }
}

class _CompassDial extends StatelessWidget {
  final double compassAngle;
  final double qiblaAngle;
  final double qiblaDegrees;
  final bool isLive;
  final double? accuracy;

  const _CompassDial({
    required this.compassAngle,
    required this.qiblaAngle,
    required this.qiblaDegrees,
    required this.isLive,
    this.accuracy,
  });

  String _accuracyLabel() {
    if (accuracy == null) return '';
    if (accuracy! <= 10) return 'High accuracy';
    if (accuracy! <= 25) return 'Medium accuracy';
    return 'Low accuracy — move your phone in a figure-8';
  }

  Color _accuracyColor() {
    if (accuracy == null) return IslamicColors.lightGold;
    if (accuracy! <= 10) return const Color(0xFF4CAF50);
    if (accuracy! <= 25) return IslamicColors.gold;
    return const Color(0xFFFF9800);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 210,
          height: 210,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: compassAngle,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(210, 210),
                      painter: _CompassRingPainter(),
                    ),
                    Transform.rotate(
                      angle: qiblaAngle,
                      child: CustomPaint(
                        size: const Size(210, 210),
                        painter: _QiblaArrowPainter(),
                      ),
                    ),
                  ],
                ),
              ),
              // Center Kaaba marker
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: IslamicColors.deepGreen,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: IslamicColors.gold,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: IslamicColors.gold.withValues(alpha: 0.3),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('🕋', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        // Bearing label
        Text(
          '${qiblaDegrees.toStringAsFixed(1)}° from North',
          style: GoogleFonts.poppins(
            color: IslamicColors.lightGold,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        if (isLive && accuracy != null) ...[
          const SizedBox(height: 4),
          Text(
            _accuracyLabel(),
            style: GoogleFonts.poppins(
              color: _accuracyColor(),
              fontSize: 11,
            ),
          ),
        ],
        if (!isLive) ...[
          const SizedBox(height: 4),
          Text(
            'No compass sensor detected',
            style: GoogleFonts.poppins(
              color: IslamicColors.lightGold.withValues(alpha: 0.6),
              fontSize: 11,
            ),
          ),
        ],
      ],
    );
  }
}

class _CompassRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;

    // Background fill
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = IslamicColors.forestGreen.withValues(alpha: 0.18)
        ..style = PaintingStyle.fill,
    );

    // Outer border
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = IslamicColors.gold.withValues(alpha: 0.45)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Inner decorative ring
    canvas.drawCircle(
      center,
      radius * 0.78,
      Paint()
        ..color = IslamicColors.gold.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // Tick marks
    for (int i = 0; i < 360; i += 10) {
      final angle = i * pi / 180;
      final isMajor = i % 90 == 0;
      final isMid = i % 30 == 0;
      final tickLen = isMajor ? 13.0 : (isMid ? 9.0 : 5.0);
      final tickPaint = Paint()
        ..color = isMajor
            ? IslamicColors.gold
            : IslamicColors.gold.withValues(alpha: 0.35)
        ..strokeWidth = isMajor ? 2.0 : 1.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final outer = Offset(
        center.dx + radius * sin(angle),
        center.dy - radius * cos(angle),
      );
      final inner = Offset(
        center.dx + (radius - tickLen) * sin(angle),
        center.dy - (radius - tickLen) * cos(angle),
      );
      canvas.drawLine(outer, inner, tickPaint);
    }

    // Cardinal letters
    final cardinals = {'N': 0.0, 'E': pi / 2, 'S': pi, 'W': 3 * pi / 2};
    final textRadius = radius - 24;

    for (final entry in cardinals.entries) {
      final angle = entry.value;
      final isNorth = entry.key == 'N';

      final tp = TextPainter(
        text: TextSpan(
          text: entry.key,
          style: TextStyle(
            color: isNorth ? IslamicColors.activeGlow : IslamicColors.lightGold,
            fontSize: isNorth ? 15 : 13,
            fontWeight: isNorth ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final offset = Offset(
        center.dx + textRadius * sin(angle) - tp.width / 2,
        center.dy - textRadius * cos(angle) - tp.height / 2,
      );
      tp.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _QiblaArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;

    // Arrow shaft (pointing up = toward Qibla)
    final arrowTip = Offset(center.dx, center.dy - radius * 0.62);
    final arrowBase = Offset(center.dx, center.dy + radius * 0.38);

    // Shaft
    canvas.drawLine(
      arrowBase,
      arrowTip,
      Paint()
        ..color = IslamicColors.gold
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );

    // Arrowhead
    final headPath = Path()
      ..moveTo(arrowTip.dx, arrowTip.dy)
      ..lineTo(arrowTip.dx - 10, arrowTip.dy + 18)
      ..lineTo(arrowTip.dx, arrowTip.dy + 10)
      ..lineTo(arrowTip.dx + 10, arrowTip.dy + 18)
      ..close();

    canvas.drawPath(
      headPath,
      Paint()
        ..color = IslamicColors.gold
        ..style = PaintingStyle.fill,
    );

    // Tail teardrop
    canvas.drawCircle(
      arrowBase,
      5,
      Paint()
        ..color = IslamicColors.gold.withValues(alpha: 0.5)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
