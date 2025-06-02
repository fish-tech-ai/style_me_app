import 'package:flutter/material.dart';
import 'package:style_me/core/navigation/app_page.dart';
import 'package:style_me/features/onboarding/onboarding_widget_factory.dart';

enum OnboardingSteps {
  first(0, OnboardingWidgetFactory.startStep, AppPage.clothingAdd),
  second(1, OnboardingWidgetFactory.addClothingStep),
  third(2, OnboardingWidgetFactory.addUserPhotoStep),
  fourth(3, OnboardingWidgetFactory.tryOnStep, AppPage.checkroom),
  fifth(4, OnboardingWidgetFactory.endStep);

  final Widget Function(Function() goToNextStep) factoryFunc;
  final AppPage? nextStepPage;
  final int value;

  const OnboardingSteps(this.value, this.factoryFunc, [this.nextStepPage]);
}