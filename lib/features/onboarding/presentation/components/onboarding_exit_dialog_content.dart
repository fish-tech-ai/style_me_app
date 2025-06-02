import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/extensions/widget_ref_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/views/buttons/app_button.dart';
import 'package:style_me/core/views/buttons/app_outlined_button.dart';

class OnboardingExitDialogContent extends ConsumerWidget {
  const OnboardingExitDialogContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      spacing: 12,
      children: [
        Text(
          localizations.onboardingExitDialogTitle,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        Text(localizations.onboardingExitDialogSubTitle),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppOutlinedButton(
              text: localizations.cancel,
              onClick: () {
                context.pop();
              },
            ),
            AppButton(
              text: localizations.onboardingExitDialogEndText,
              onClick: () {
                ref.globalViewModel.onboardingStop();
              },
            )
          ],
        )
      ],
    );
  }
}
