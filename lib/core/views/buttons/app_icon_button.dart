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

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onClick,
    this.backgroundColor,
    this.elevation = 0,
    this.padding = const EdgeInsets.all(GlobalUiConst.paddingNormal),
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = this.backgroundColor ?? context.colorScheme.primary;
    return IntrinsicWidth(
      child: InkWell(
        onTap: onClick,
        borderRadius: GlobalUiConst.borderRadiusLarge,
        child: Material(
          elevation: elevation,
          shape: RoundedRectangleBorder(
              borderRadius: GlobalUiConst.borderRadiusLarge),
          child: Container(
              padding: padding,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: GlobalUiConst.borderRadiusLarge,
                border: border,
              ),
              child: icon),
        ),
      ),
    );
  }
}
