import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/views/containers/bottom_sheet_container.dart';

void debugMessagePrint(String message, [String label = ""]) {
  if (kDebugMode) {
    print("$label$message");
  }
}

void showAppDialog({
  required BuildContext context,
  required Widget child,
  Function()? onDismiss,
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
  ).then((_) {
    onDismiss?.call();
  });
}

void showAppModalBottomSheet({
  required BuildContext context,
  required Widget child,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) {
      return BottomSheetContainer(child: child);
    },
  );
}
