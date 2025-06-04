import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/utils/constants.dart';

class AppIconButton extends StatelessWidget {
  final Widget icon;
  final Function() onClick;
  final Color? backgroundColor;
  final double elevation;
  final bool disableVisualFeedback;
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
    this.disableVisualFeedback = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = this.backgroundColor ?? context.colorScheme.primary;
    final borderRadius = this.borderRadius ?? GlobalUiConst.borderRadiusLarge;
    return IntrinsicWidth(
      child: InkWell(
        onTap: onClick,
        splashColor: disableVisualFeedback ? Colors.transparent : null,
        highlightColor: disableVisualFeedback ? Colors.transparent : null,
        hoverColor: disableVisualFeedback ? Colors.transparent : null,
        borderRadius: GlobalUiConst.borderRadiusLarge,
        child: _buildElevationContainer(
          borderRadius: borderRadius,
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

  Widget _buildElevationContainer(
      {required BorderRadius borderRadius, required Widget child}) {
    if (elevation <= 0) {
      return child;
    }
    return Material(
        elevation: elevation,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        child: child);
  }
}
