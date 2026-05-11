import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../settings/settings_provider.dart';

/// Eight-point star (khatim) — the recurring motif in Islamic geometry. Used
/// as a small medallion in dividers and section headers.
class IslamicOrnament extends StatelessWidget {
  final double size;
  final Color color;
  final bool filled;
  final double innerRatio;

  const IslamicOrnament({
    super.key,
    required this.size,
    required this.color,
    this.filled = true,
    this.innerRatio = 0.42,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _OrnamentPainter(
          color: color,
          filled: filled,
          innerRatio: innerRatio,
        ),
      ),
    );
  }
}

class _OrnamentPainter extends CustomPainter {
  final Color color;
  final bool filled;
  final double innerRatio;

  _OrnamentPainter({
    required this.color,
    required this.filled,
    required this.innerRatio,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerR = size.width / 2;
    final innerR = outerR * innerRatio;

    final path = Path();
    for (int i = 0; i < 16; i++) {
      final angle = (i * pi / 8) - pi / 2;
      final r = i.isEven ? outerR : innerR;
      final x = center.dx + r * cos(angle);
      final y = center.dy + r * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    final paint = Paint()
      ..color = color
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    if (filled) {
      paint.style = PaintingStyle.fill;
    } else {
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 1.0;
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_OrnamentPainter old) =>
      old.color != color || old.filled != filled || old.innerRatio != innerRatio;
}

/// Section divider styled after a masjid inscription band: a gold hairline
/// fading in from the left, an eight-point medallion, the title, another
/// medallion, and a hairline fading out to the right.
class IslamicDivider extends StatelessWidget {
  final String label;
  final double labelSize;
  final double letterSpacing;

  const IslamicDivider({
    super.key,
    required this.label,
    this.labelSize = 11,
    this.letterSpacing = 2.4,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      children: [
        Expanded(child: _Hairline(color: c.accent, fadeFromStart: true)),
        const SizedBox(width: 9),
        IslamicOrnament(size: 7, color: c.accent),
        const SizedBox(width: 8),
        Text(
          label.toUpperCase(),
          style: GoogleFonts.poppins(
            color: c.accent.withValues(alpha: 0.9),
            fontSize: labelSize,
            fontWeight: FontWeight.w600,
            letterSpacing: letterSpacing,
          ),
        ),
        const SizedBox(width: 8),
        IslamicOrnament(size: 7, color: c.accent),
        const SizedBox(width: 9),
        Expanded(child: _Hairline(color: c.accent, fadeFromStart: false)),
      ],
    );
  }
}

class _Hairline extends StatelessWidget {
  final Color color;
  // When true, the line fades from transparent → solid (used on the left side
  // so the eye flows into the centerpiece). False is the mirror.
  final bool fadeFromStart;
  const _Hairline({required this.color, required this.fadeFromStart});

  @override
  Widget build(BuildContext context) {
    final colors = fadeFromStart
        ? [color.withValues(alpha: 0), color.withValues(alpha: 0.45)]
        : [color.withValues(alpha: 0.45), color.withValues(alpha: 0)];
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
      ),
    );
  }
}

/// Faint repeating star backdrop drawn inside a card's bounds. Reads as
/// texture, never as decoration.
class IslamicWatermark extends StatelessWidget {
  final Color color;
  final double opacity;
  final double size;

  const IslamicWatermark({
    super.key,
    required this.color,
    this.opacity = 0.05,
    this.size = 140,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _WatermarkPainter(
          color: color.withValues(alpha: opacity),
          starSize: size,
        ),
      ),
    );
  }
}

class _WatermarkPainter extends CustomPainter {
  final Color color;
  final double starSize;

  _WatermarkPainter({required this.color, required this.starSize});

  @override
  void paint(Canvas canvas, Size size) {
    // Single large star drawn off the right edge so the visible portion looks
    // like a watermark stamp on parchment.
    final center = Offset(size.width - starSize * 0.25, size.height / 2);
    final outerR = starSize / 2;
    final innerR = outerR * 0.42;

    final path = Path();
    for (int i = 0; i < 16; i++) {
      final angle = (i * pi / 8) - pi / 2;
      final r = i.isEven ? outerR : innerR;
      final x = center.dx + r * cos(angle);
      final y = center.dy + r * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  @override
  bool shouldRepaint(_WatermarkPainter old) =>
      old.color != color || old.starSize != starSize;
}
