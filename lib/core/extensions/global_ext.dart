import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:style_me/core/views/containers/bottom_sheet_container.dart';
import 'package:style_me/core/views/popups/app_dialog_wrapper.dart';

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
      return AppDialogWrapper(
        onDismiss: onDismiss,
        borderColor: borderColor,
        child: child,
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
