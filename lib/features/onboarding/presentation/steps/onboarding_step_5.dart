import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style_me/core/extensions/widget_ref_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/features/onboarding/presentation/components/onboarding_stack_page.dart';

class OnboardingStep5 extends ConsumerWidget {
  const OnboardingStep5({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OnboardingStackPage.simple(
      title: localizations.onboardingStep5Title,
      subtitle: localizations.onboardingStep5SubTitle,
      onContinueClicked: () {
        ref.globalViewModel.onboardingStop();
      },
    );
  }
}
