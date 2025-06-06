import 'package:flutter/material.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/views/buttons/app_button.dart';
import 'package:style_me/core/views/buttons/app_outlined_button.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final String description;
  final Widget buttonsRow;

  const AppDialog({
    super.key,
    required this.title,
    required this.description,
    required this.buttonsRow,
  });

  AppDialog.twoButtons({
    super.key,
    required this.title,
    required this.description,
    String? cancelButtonText,
    required String actionButtonText,
    Color? actionButtonBackgroundColor,
    required Function() onActionButtonClicked,
    required Function() onCancelButtonClicked,
  }) : buttonsRow = Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppOutlinedButton(
              text: cancelButtonText ?? localizations.cancel,
              width: 120,
              height: 46,
              onClick: onCancelButtonClicked,
            ),
            AppButton(
              text: actionButtonText,
              height: 46,
              backgroundColor: actionButtonBackgroundColor,
              onClick: onActionButtonClicked,
            ),
          ],
        );

  AppDialog.oneButton({
    super.key,
    required this.title,
    required this.description,
    required String buttonText,
    Color? buttonBackgroundColor,
    required Function() onButtonClicked,
  }) : buttonsRow = Center(
          child: AppButton(
            text: buttonText,
            padding: EdgeInsets.symmetric(horizontal: 24),
            height: 46,
            backgroundColor: buttonBackgroundColor,
            onClick: onButtonClicked,
          ),
        );

  @override
  Widget build(BuildContext context) {
    return Column(spacing: 12, mainAxisSize: MainAxisSize.min, children: [
      Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
      Text(description, textAlign: TextAlign.center),
      buttonsRow
    ]);
  }
}
