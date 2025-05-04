import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';

class BottomSheetContainer extends StatelessWidget {
  final Widget child;
  final bool shouldAlignBottom;

  const BottomSheetContainer({
    super.key,
    required this.child,
    this.shouldAlignBottom = true,
  });

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom - 60;
    return Padding(
      padding: shouldAlignBottom
          ? EdgeInsets.only(
              bottom: keyboardHeight.isNegative ? 0 : keyboardHeight)
          : EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          color: context.theme.dialogBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          border: Border(
            top: BorderSide(color: context.colorScheme.primary, width: 1),
            left: BorderSide(color: context.colorScheme.primary, width: 1),
            right: BorderSide(color: context.colorScheme.primary, width: 1),
            bottom: BorderSide.none,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 8),
            Container(
              height: 2,
              width: 64,
              decoration: BoxDecoration(
                  color: context.theme.hintColor,
                  borderRadius: BorderRadius.circular(32)),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
