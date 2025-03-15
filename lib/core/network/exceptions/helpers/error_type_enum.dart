import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/extensions/global_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/views/dialogs/app_dialog.dart';

enum ImageErrorTypeEnum {
  NOT_A_CLOTHING,
  CANT_PROCESS,
  NOT_A_PERSON,
  NSFW_PICTURE;

  void showImageProcessErrorDialog(BuildContext context, Function() onDismiss) {
    late final Widget dialog;
    switch (this) {
      case ImageErrorTypeEnum.NOT_A_CLOTHING:
        dialog = AppDialog.oneButton(
          title: localizations.errorDialogNotAClothingTitle,
          description: localizations.errorDialogNotAClothingDesc,
          buttonText: localizations.tryAgain,
          onButtonClicked: () => context.pop(),
        );
      case ImageErrorTypeEnum.CANT_PROCESS:
        dialog = AppDialog.oneButton(
          title: localizations.errorDialogCantProcessTitle,
          description: localizations.errorDialogCantProcessDesc,
          buttonText: localizations.tryAgain,
          onButtonClicked: () => context.pop(),
        );
      case ImageErrorTypeEnum.NOT_A_PERSON:
        dialog = AppDialog.oneButton(
          title: localizations.errorDialogNotAPersonTitle,
          description: localizations.errorDialogNotAPersonDesc,
          buttonText: localizations.tryAgain,
          onButtonClicked: () => context.pop(),
        );
      case ImageErrorTypeEnum.NSFW_PICTURE:
        dialog = AppDialog.oneButton(
          title: localizations.errorDialogNSFWTitle,
          description: localizations.errorDialogNSFWDesc,
          buttonText: localizations.tryAgain,
          onButtonClicked: () => context.pop(),
        );
    }
    showAppDialog(context: context, child: dialog, onDismiss: onDismiss);
  }
}
