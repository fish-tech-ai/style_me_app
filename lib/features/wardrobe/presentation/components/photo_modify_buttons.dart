import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/views/buttons/app_button.dart';
import 'package:style_me/core/views/buttons/app_outlined_button.dart';

class PhotoModifyButtons extends StatelessWidget {
  final bool isDeleteLoading;
  final bool isSaveLoading;
  final Function() onDeleteClicked;
  final Function() onSaveClicked;

  const PhotoModifyButtons({
    super.key,
    required this.isDeleteLoading,
    required this.isSaveLoading,
    required this.onDeleteClicked,
    required this.onSaveClicked,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        AppOutlinedButton(
          text: localizations.deleteClothing,
          style: OutlinedButton.styleFrom(
            foregroundColor: context.colorScheme.error,
            backgroundColor: context.colorScheme.onError,
            side: BorderSide(color: context.colorScheme.error),
          ),
          isLoading: isDeleteLoading,
          onClick: onDeleteClicked,
        ),
        AppButton(
          text: localizations.save,
          isLoading: isSaveLoading,
          onClick: onSaveClicked,
        ),
      ],
    );
  }
}
