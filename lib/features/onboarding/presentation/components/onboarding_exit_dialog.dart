import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style_me/core/extensions/widget_ref_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/views/popups/app_dialog.dart';
import 'package:style_me/core/views/popups/app_dialog_wrapper.dart';

class OnboardingExitDialog extends ConsumerWidget {
  const OnboardingExitDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppDialogWrapper(
      onDismiss: () => ref.globalViewModel.hideOnboardingExitDialog(),
      child: AppDialog.twoButtons(
        title: localizations.onboardingExitDialogTitle,
        description: localizations.onboardingExitDialogSubTitle,
        actionButtonText: localizations.onboardingExitDialogEndText,
        onActionButtonClicked: () {
          ref.globalViewModel.onboardingStop();
          ref.globalViewModel.hideOnboardingExitDialog();
        },
        onCancelButtonClicked: () =>
            ref.globalViewModel.hideOnboardingExitDialog(),
      ),
    );
  }
}
