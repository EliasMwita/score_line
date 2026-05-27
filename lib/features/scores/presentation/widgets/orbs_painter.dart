import 'package:flutter/material.dart';
import 'dart:math' as math;

class OrbsPainter extends CustomPainter {
  final double progress;

  OrbsPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50);

    paint.color = Colors.white.withOpacity(0.15);
    canvas.drawCircle(
      Offset(
        size.width * (0.2 + 0.3 * math.sin(progress * 2 * math.pi)),
        size.height * (0.3 + 0.2 * math.cos(progress * 2 * math.pi)),
      ),
      60,
      paint,
    );

    paint.color = Colors.white.withOpacity(0.1);
    canvas.drawCircle(
      Offset(
        size.width * (0.7 + 0.2 * math.cos(progress * 2 * math.pi + 1)),
        size.height * (0.5 + 0.3 * math.sin(progress * 2 * math.pi + 1)),
      ),
      70,
      paint,
    );
  }

  @override
  bool shouldRepaint(OrbsPainter oldDelegate) => true;
}
