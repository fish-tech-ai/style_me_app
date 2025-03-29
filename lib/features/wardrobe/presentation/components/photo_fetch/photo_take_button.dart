import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';

class PhotoTakeButton extends StatelessWidget {
  final Function() onClick;

  const PhotoTakeButton({super.key, required this.onClick});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(100);
    return InkWell(
      onTap: onClick,
      child: Container(
        height: 72,
        width: 72,
        alignment: Alignment.center,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: context.colorScheme.secondary,
          borderRadius: borderRadius,
          border: Border.all(color: context.colorScheme.primary),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: context.colorScheme.primary,
            borderRadius: borderRadius,
          ),
        ),
      ),
    );
  }
}
