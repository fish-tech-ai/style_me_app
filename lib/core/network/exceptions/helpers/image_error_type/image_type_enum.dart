import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/extensions/global_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/network/exceptions/helpers/image_error_type/error_dialog_data.dart';
import 'package:style_me/core/views/popups/app_dialog.dart';

// ignore_for_file: constant_identifier_names
enum ImageErrorTypeEnum {
  IMAGE_IS_NSFW,
  NO_CLOTHING_DETECTED,
  NO_PERSON_ON_IMAGE,
  NO_FILE_PROVIDED,
  NO_ID_PROVIDED,
  NO_SELECTED_FILE,
  FILE_TYPE_NOT_ALLOWED,
  IMAGE_DECRYPTION_FAILED,
  NO_GARMENT_ID_PROVIDED,
  NO_USER_ID_PROVIDED,
  NO_USER_IMAGE_ID_PROVIDED,
  CANT_PROCESS;

  void showImageProcessErrorDialog(BuildContext context, Function() onDismiss) {
    final errorDialogData =
        _errorDialogConfig[this] ?? _defaultErrorDialogConfig;

    final dialog = AppDialog.oneButton(
      title: errorDialogData.title,
      description: errorDialogData.description,
      buttonText: localizations.tryAgain,
      onButtonClicked: () => context.pop(),
    );

    showAppDialog(context: context, child: dialog, onDismiss: onDismiss);
  }

  static final _errorDialogConfig = {
    ImageErrorTypeEnum.NO_CLOTHING_DETECTED: ErrorDialogData(
      title: localizations.errorDialogNotAClothingTitle,
      description: localizations.errorDialogNotAClothingDesc,
    ),
    ImageErrorTypeEnum.NO_PERSON_ON_IMAGE: ErrorDialogData(
      title: localizations.errorDialogNotAPersonTitle,
      description: localizations.errorDialogNotAPersonDesc,
    ),
    ImageErrorTypeEnum.IMAGE_IS_NSFW: ErrorDialogData(
      title: localizations.errorDialogNSFWTitle,
      description: localizations.errorDialogNSFWDesc,
    ),
  };

  static final _defaultErrorDialogConfig = ErrorDialogData(
    title: localizations.errorDialogCantProcessTitle,
    description: localizations.errorDialogCantProcessDesc,
  );
}
