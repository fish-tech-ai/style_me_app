import 'package:android_gesture_exclusion/android_gesture_exclusion.dart';
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
    final borderRadius = BorderRadius.horizontal(left: Radius.circular(32));
    return AndroidGestureExclusionContainer(
      horizontalExclusionMargin: 0,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Padding(
          padding: EdgeInsets.only(
              bottom: keyboardHeight.isNegative ? 0 : keyboardHeight),
          child: Container(
            decoration: BoxDecoration(
              color: context.theme.dialogBackgroundColor,
              borderRadius: borderRadius,
              border: Border(
                top: BorderSide(color: context.colorScheme.primary, width: 1),
                right: BorderSide.none,
                left: BorderSide(color: context.colorScheme.primary, width: 1),
                bottom:
                    BorderSide(color: context.colorScheme.primary, width: 1),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 11),
                Container(
                  height: 64,
                  width: 2,
                  decoration: BoxDecoration(
                      color: context.theme.hintColor,
                      borderRadius: BorderRadius.circular(32)),
                ),
                SizedBox(width: 16),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
