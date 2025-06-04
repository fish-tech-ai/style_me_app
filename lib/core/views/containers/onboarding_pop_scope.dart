

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/extensions/widget_ref_ext.dart';

class OnboardingPopScope extends ConsumerWidget {
  final Widget child;

  /// If returns `true`, blocks the onboarding exit dialog and handles pop manually.
  final bool Function()? handlePopBeforeDialogExitShow;
  final Function()? onOnboardingNotRunning;
  final bool? ownCanPop;

  const OnboardingPopScope({
    super.key,
    required this.child,
    this.handlePopBeforeDialogExitShow,
    this.onOnboardingNotRunning,
    this.ownCanPop,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: ownCanPop ?? !ref.globalState.isOnboardingRunning,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (handlePopBeforeDialogExitShow?.call() == true) {
          return;
        }
        if (ref.globalState.isOnboardingRunning) {
          ref.globalViewModel.showOnboardingExitDialog();
        } else {
          onOnboardingNotRunning?.call() ?? context.pop();
        }
      },
      child: child,
    );
  }
}
