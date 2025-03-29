import 'package:flutter/material.dart';

class LabelClipper extends CustomClipper<Path> {
  final double labelWidth;

  LabelClipper(this.labelWidth);

  @override
  Path getClip(Size size) {
    double labelHeight = 14;

    Path path = Path()
      ..lineTo(12, 0)
      ..lineTo(12, labelHeight)
      ..lineTo(labelWidth, labelHeight)
      ..lineTo(labelWidth, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
