import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';

class AppDialogWrapper extends StatelessWidget {
  final Widget child;
  final Function()? onDismiss;
  final Color? borderColor;

  const AppDialogWrapper({super.key, required this.child, this.onDismiss, this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: borderColor ?? context.colorScheme.primary, width: 1),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Padding(
        padding: EdgeInsets.all(18),
        child: child,
      ),
    );
  }
}
