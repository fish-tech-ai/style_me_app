import 'package:flutter/material.dart';

class DefaultLoading extends StatelessWidget {
  final Color? color;
  final Size? size;

  const DefaultLoading({super.key, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          width: size?.width,
          height: size?.height,
          child: CircularProgressIndicator(color: color)),
    );
  }
}
