import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';

void debugMessagePrint(String message) {
  if (kDebugMode) {
    print(message);
  }
}

void showAppDialog({
  required BuildContext context,
  required Widget child,
  Color? borderColor,
}) {
  showDialog(
    context: context,
    builder: (_) {
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
    },
  );
}

void showAppModalBottomSheet({
  required BuildContext context,
  required Widget child,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) {
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom - 60;
      return Padding(
        padding: EdgeInsets.only(
            bottom: keyboardHeight.isNegative ? 0 : keyboardHeight),
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
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(height: 8),
              Container(
                height: 2,
                width: 64,
                decoration: BoxDecoration(
                    color: context.theme.hintColor,
                    borderRadius: BorderRadius.circular(32)),
              ),
              child,
            ])),
      );
    },
  );
}
