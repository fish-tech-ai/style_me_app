import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/views/buttons/app_button.dart';
import 'package:style_me/core/views/buttons/countdown_button.dart';
import 'package:style_me/core/views/ui_models/app_button_icon.dart';
import 'package:style_me/core/views/ui_models/icon_position.dart';

class AuthEmailConfirmation extends StatelessWidget {
  final bool asWarning;
  final Function() onBackToLoginClicked;
  final Function() onResendClicked;

  const AuthEmailConfirmation(
      {super.key,
      required this.asWarning,
      required this.onBackToLoginClicked,
      required this.onResendClicked});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 18,
      children: [
        Icon(
          asWarning ? Icons.error_rounded : Icons.check_circle_rounded,
          size: 80,
          color: context.colorScheme.primary,
        ),
        Text(
          asWarning
              ? context.localizations.authWarningEmailSentTitle
              : context.localizations.authEmailSentTitle,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),
        Text(
          asWarning
              ? context.localizations.authWarningEmailSentText
              : context.localizations.authEmailSentText,
          textAlign: TextAlign.center,
        ),
        AppButton(
          text: context.localizations.backToLogin,
          onClick: onBackToLoginClicked,
          icon: AppButtonIcon(
            Icons.keyboard_arrow_right_rounded,
            IconPosition.trailing,
          ),
        ),
        Column(
          spacing: 6,
          children: [
            Text(context.localizations.resendEmailLabel),
            CountdownOutlinedButton(
              text: context.localizations.resendEmail,
              onClick: onResendClicked,
            )
          ],
        )
      ],
    );
  }
}
