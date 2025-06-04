import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style_me/core/extensions/widget_ref_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/features/onboarding/presentation/components/onboarding_stack_page.dart';

class OnboardingStep4 extends ConsumerWidget {
  final Function goToNextPage;

  const OnboardingStep4(this.goToNextPage, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OnboardingStackPage.simple(
      title: localizations.onboardingStep4Title,
      subtitle: localizations.onboardingStep4SubTitle,
      onContinueClicked: () {
        ref.globalViewModel.hideCurrentOnboardingPageStep();
        goToNextPage();
      },
    );
  }
}
