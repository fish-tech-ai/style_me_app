import 'package:flutter/material.dart';

class AbsolutePercentagePositioned extends StatelessWidget {
  /// values from 0-1
  final double y;
  final double x;
  final Widget child;

  const AbsolutePercentagePositioned({
    super.key,
    this.y = 0,
    this.x = 0,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Positioned(
      top: size.height * y,
      left: size.width * x,
      child: child,
    );
  }
}
