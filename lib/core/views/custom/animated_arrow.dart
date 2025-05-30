import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';

import 'package:style_me/core/views/custom/arrow_painter.dart';

class AnimatedArrow extends StatelessWidget {
  final Offset sourcePosition;
  final Offset targetPosition;
  final Duration duration;
  final Color? color;
  final Curve animCurve;
  final double curvature;

  const AnimatedArrow({
    super.key,
    required this.sourcePosition,
    required this.targetPosition,
    this.duration = const Duration(seconds: 1),
    this.animCurve = Curves.easeInOut,
    this.color,
    this.curvature = 0.4,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final fullSize = Size(constraints.maxWidth, constraints.maxHeight);

      return TweenAnimationBuilder<Offset>(
        tween: Tween<Offset>(
          begin: sourcePosition,
          end: targetPosition,
        ),
        duration: duration,
        curve: animCurve,
        builder: (context, normalizedOffset, _) {
          final startPoint = Offset(
            sourcePosition.dx * fullSize.width,
            sourcePosition.dy * fullSize.height,
          );
          final endPoint = Offset(
            normalizedOffset.dx * fullSize.width,
            normalizedOffset.dy * fullSize.height,
          );

          return IgnorePointer(
            child: CustomPaint(
              size: fullSize,
              painter: ArrowPainter(
                color: color ?? context.colorScheme.onSurface,
                curvature: curvature,
                from: startPoint,
                to: endPoint,
              ),
            ),
          );
        },
      );
    });
  }
}
