import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/features/onboarding/presentation/onboarding_steps.dart';

class OnboardingStepWidgetProvider extends StatelessWidget {
  final GoRouter router;
  final int step;

  const OnboardingStepWidgetProvider(
      {super.key, required this.router, required this.step});

  @override
  Widget build(BuildContext context) {
    assert(step >= 0 && step < OnboardingSteps.values.length,
        "Onboarding out of range");
    final currentStep = OnboardingSteps.values.firstWhereIndexedOrNull(
      (index, _) => index == step,
    );
    if (currentStep != null) {
      return currentStep.factoryFunc(() {
        if (currentStep.nextStepPage != null) {
          router.push(currentStep.nextStepPage!.path);
        }
      });
    }
    
    return SizedBox();
  }
}
