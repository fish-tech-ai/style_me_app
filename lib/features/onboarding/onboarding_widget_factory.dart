import 'package:flutter/material.dart';
import 'package:style_me/features/onboarding/presentation/steps/onboarding_step_1.dart';
import 'package:style_me/features/onboarding/presentation/steps/onboarding_step_2.dart';
import 'package:style_me/features/onboarding/presentation/steps/onboarding_step_3.dart';
import 'package:style_me/features/onboarding/presentation/steps/onboarding_step_4.dart';
import 'package:style_me/features/onboarding/presentation/steps/onboarding_step_5.dart';

abstract class OnboardingWidgetFactory {
  static Widget startStep(Function() goToNextStep) {
    return OnboardingStep1(goToNextStep: goToNextStep);
  }

  static Widget addClothingStep(Function() goToNextStep) {
    return OnboardingStep2();
  }

  static Widget addUserPhotoStep(Function() goToNextStep) {
    return OnboardingStep3();
  }

  static Widget tryOnStep(Function() goToNextStep) {
    return OnboardingStep4(goToNextStep);
  }

  static Widget endStep(Function() goToNextStep) {
    return OnboardingStep5();
  }
}
