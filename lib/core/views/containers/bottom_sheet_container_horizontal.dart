import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';

class BottomSheetContainerHorizontal extends StatelessWidget {
  final Widget child;

  const BottomSheetContainerHorizontal({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom - 60;
    final borderRadius = BorderRadius.horizontal(right: Radius.circular(32));
    return ClipRRect(
      borderRadius: borderRadius,
      child: Material(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.only(
              bottom: keyboardHeight.isNegative ? 0 : keyboardHeight),
          child: Container(
            decoration: BoxDecoration(
              color: context.theme.dialogBackgroundColor,
              borderRadius: borderRadius,
              border: Border(
                top: BorderSide(color: context.colorScheme.primary, width: 1),
                left: BorderSide.none,
                right: BorderSide(color: context.colorScheme.primary, width: 1),
                bottom:
                    BorderSide(color: context.colorScheme.primary, width: 1),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: child),
                SizedBox(width: 16),
                Container(
                  height: 64,
                  width: 2,
                  decoration: BoxDecoration(
                      color: context.theme.hintColor,
                      borderRadius: BorderRadius.circular(32)),
                ),
                SizedBox(width: 11),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
