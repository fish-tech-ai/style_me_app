import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/views/buttons/app_button.dart';
import 'package:style_me/core/views/buttons/countdown_button.dart';
import 'package:style_me/core/views/ui_models/app_button_icon_data.dart';
import 'package:style_me/core/views/ui_models/icon_position.dart';

class AuthEmailConfirmation extends StatelessWidget {
  final bool asWarning;
  final bool asResetPassword;
  final Function() onBackToLoginClicked;
  final Function() onResendClicked;

  const AuthEmailConfirmation({
    super.key,
    required this.asWarning,
    required this.onBackToLoginClicked,
    required this.onResendClicked,
    required this.asResetPassword,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.localizations;
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
              ? texts.authWarningEmailSentTitle
              : texts.authEmailSentTitle,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),
        Text(
          asWarning
              ? texts.authWarningEmailSentText
              : asResetPassword
                  ? texts.authResetEmailSentText
                  : texts.authEmailSentText,
          textAlign: TextAlign.center,
        ),
        AppButton(
          text: texts.backToLogin,
          onClick: onBackToLoginClicked,
          icon: AppButtonIconData.iconData(
            Icons.keyboard_arrow_right_rounded,
            IconPosition.trailing,
          ),
        ),
        Column(
          spacing: 6,
          children: [
            Text(texts.resendEmailLabel),
            CountdownOutlinedButton(
              text: texts.resendEmail,
              onClick: onResendClicked,
            )
          ],
        )
      ],
    );
  }
}
