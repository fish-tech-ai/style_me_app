import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style_me/core/extensions/widget_ref_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/features/onboarding/presentation/components/onboarding_stack_page.dart';

class OnboardingStep3 extends ConsumerWidget {
  const OnboardingStep3({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OnboardingStackPage.simple(
      title: localizations.onboardingStep3Title("Suzan"), //TODO replace with real name
      subtitle: localizations.onboardingStep3SubTitle,
      onContinueClicked: () {
        ref.globalViewModel.hideCurrentOnboardingPageStep();
      },
    );
  }
}
