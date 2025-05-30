import 'package:flutter/material.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/views/buttons/floating/page_with_floating_add_button.dart';
import 'package:style_me/features/onboarding/presentation/components/onboarding_page.dart';

abstract class OnboardingWidgetFactory {
  static Widget step1() {
    return OnboardingStackPage.simple(
      title: localizations.onboardingStep1Title("Suzan"),
      subtitle: localizations.onboardingStep1SubTitle,
      target: Offset(0.8, 0.88),
      children: [
        Positioned.fill(
          child: PageWithFloatingAddButton(
            addClothingClicked: () {},
            addUserPhotoClicked: () {},
            margin: EdgeInsets.only(right: 24, bottom: 56),
            child: SizedBox(),
          ),
        ),
      ],
    );
  }
}
