import 'dart:math';

import 'package:flutter/material.dart';

class ArrowPainter extends CustomPainter {
  final Offset from;
  final Offset to;
  final double arrowHeadSize;
  final Color color;
  final double curvature;

  ArrowPainter({
    required this.from,
    required this.to,
    this.arrowHeadSize = 24.0,
    this.color = Colors.red,
    this.curvature = 0.2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

    final midPoint = Offset((from.dx + to.dx) / 2, (from.dy + to.dy) / 2);

    final controlPoint = midPoint.translate(
      -(to.dy - from.dy) * curvature,
      (to.dx - from.dx) * curvature,
    );

    final path = Path()
      ..moveTo(from.dx, from.dy)
      ..quadraticBezierTo(
        controlPoint.dx,
        controlPoint.dy,
        to.dx,
        to.dy,
      );

    canvas.drawPath(path, paint);

    final dx = to.dx - controlPoint.dx;
    final dy = to.dy - controlPoint.dy;
    final angle = atan2(dy, dx);

    final arrowHeadPath = Path()
      ..moveTo(to.dx, to.dy)
      ..lineTo(
        to.dx - arrowHeadSize * cos(angle - pi / 6),
        to.dy - arrowHeadSize * sin(angle - pi / 6),
      )
      ..moveTo(to.dx, to.dy)
      ..lineTo(
        to.dx - arrowHeadSize * cos(angle + pi / 6),
        to.dy - arrowHeadSize * sin(angle + pi / 6),
      );

    canvas.drawPath(arrowHeadPath, paint);
  }

  @override
  bool shouldRepaint(covariant ArrowPainter oldDelegate) {
    return from != oldDelegate.from || to != oldDelegate.to;
  }
}
