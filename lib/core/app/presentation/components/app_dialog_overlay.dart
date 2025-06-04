import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';

class AppDialogOverlay extends StatelessWidget {
  final Widget child;
  final Function()? onDismiss;
  const AppDialogOverlay({super.key, required this.child, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onDismiss,
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          color: context.customColors.backgroundA85,
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
