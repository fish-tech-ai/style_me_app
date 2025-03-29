import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/utils/constants.dart';

class AppIconButton extends StatelessWidget {
  final Widget icon;
  final Function() onClick;
  final Color? backgroundColor;
  final double elevation;
  final EdgeInsets padding;
  final BoxBorder? border;
  final BorderRadius? borderRadius;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onClick,
    this.backgroundColor,
    this.elevation = 0,
    this.padding = const EdgeInsets.all(16),
    this.border,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = this.backgroundColor ?? context.colorScheme.primary;
    final borderRadius = this.borderRadius ?? GlobalUiConst.borderRadiusLarge;
    return IntrinsicWidth(
      child: InkWell(
        onTap: onClick,
        borderRadius: GlobalUiConst.borderRadiusLarge,
        child: Material(
          elevation: elevation,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          child: Container(
              padding: padding,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: borderRadius,
                border: border,
              ),
              child: icon),
        ),
      ),
    );
  }
}
