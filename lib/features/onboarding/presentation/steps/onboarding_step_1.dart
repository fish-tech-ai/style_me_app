import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style_me/core/extensions/widget_ref_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/views/buttons/floating/add_photo_menu_button.dart';
import 'package:style_me/features/onboarding/presentation/components/onboarding_stack_page.dart';

class OnboardingStep1 extends ConsumerStatefulWidget {
  final Function() goToNextStep;

  const OnboardingStep1({super.key, required this.goToNextStep});

  @override
  ConsumerState<OnboardingStep1> createState() => _OnboardingStep1State();
}

class _OnboardingStep1State extends ConsumerState<OnboardingStep1> {
  bool isExpanded = false;
  Offset target = Offset(0.8, 0.84);

  @override
  Widget build(BuildContext context) {
    return OnboardingStackPage.simple(
      title: localizations.onboardingStep1Title(ref.globalState.userName),
      subtitle: isExpanded
          ? localizations.onboardingStep1SubTitle2
          : localizations.onboardingStep1SubTitle,
      source: Offset(0.38, 0.58),
      target: target,
      children: [
        Positioned(
          right: 24,
          bottom: 80,
          child: AddPhotoMenuButton(
            isExpanded: isExpanded,
            onClicked: () => setState(() {
              target = Offset(0.38, 0.7);
              isExpanded = true;
            }),
            addClothingClicked: () {
              ref.globalViewModel.hideCurrentOnboardingPageStep();
              return widget.goToNextStep();
            },
            addUserPhotoClicked: () {},
          ),
        ),
      ],
    );
  }
}
