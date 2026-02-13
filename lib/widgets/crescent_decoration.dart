import 'package:flutter/material.dart';

class CrescentMoonPainter extends CustomPainter {
  final Color color;

  CrescentMoonPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    final paint = Paint()..color = color;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    canvas.drawCircle(center, radius, paint);

    final erasePaint = Paint()..blendMode = BlendMode.clear;
    final eraseCenter = Offset(center.dx + radius * 0.35, center.dy);
    canvas.drawCircle(eraseCenter, radius * 0.85, erasePaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CrescentMoon extends StatelessWidget {
  final double size;
  final Color color;

  const CrescentMoon({
    super.key,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: CrescentMoonPainter(color: color),
    );
  }
}
