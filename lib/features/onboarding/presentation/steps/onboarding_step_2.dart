import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style_me/core/extensions/widget_ext.dart';
import 'package:style_me/core/extensions/widget_ref_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/views/buttons/app_icon_button.dart';
import 'package:style_me/core/views/custom/absolute_percentage_positioned.dart';
import 'package:style_me/core/views/custom/animated_arrow.dart';
import 'package:style_me/features/onboarding/presentation/components/onboarding_stack_page.dart';
import 'package:style_me/features/wardrobe/presentation/components/photo_fetch/photo_take_button.dart';

class OnboardingStep2 extends ConsumerStatefulWidget {
  const OnboardingStep2({super.key});

  @override
  ConsumerState<OnboardingStep2> createState() => _OnboardingStep2State();
}

class _OnboardingStep2State extends ConsumerState<OnboardingStep2> {
  int subStep = 0;

  @override
  Widget build(BuildContext context) {
    return OnboardingStackPage(
        onContinueClicked: () {
          if (subStep >= 2) {
            ref.globalViewModel.hideCurrentOnboardingPageStep();
            return;
          }
          setState(() {
            subStep = subStep + 1;
          });
        },
        isControlsPositionTop: true,
        children: [
          _buildText(
            text: localizations.onboardingStep2Text1,
            position: Offset(0.35, 0.40),
            width: 200,
          ),
          AnimatedArrow(
            sourcePosition: Offset(0.65, 0.56),
            targetPosition: Offset(0.60, 0.85),
            curvature: -0.4,
          ),
          _buildAddPhotoButton(),
          _buildGalleryButton(),
          _buildCopyFromClipboardButton(),
          ...buildSecondSubStep().orEmpty(subStep == 0),
          ...buildThirdSubStep().orEmpty(subStep != 2)
        ]);
  }

  List<Widget> buildSecondSubStep() {
    return [
      _buildText(
        text: localizations.onboardingStep2Text2,
        position: Offset(0.10, 0.64),
        width: 200,
      ),
      AnimatedArrow(
        sourcePosition: Offset(0.30, 0.80),
        targetPosition: Offset(0.18, 0.89),
        curvature: 0.2,
      ),
    ];
  }

  List<Widget> buildThirdSubStep() {
    return [
      _buildText(
        text: localizations.onboardingStep2Text3,
        position: Offset(0.1, 0.22),
        width: 300,
      ),
      AnimatedArrow(
        sourcePosition: Offset(0.5, 0.24),
        targetPosition: Offset(0.8, 0.12),
        curvature: -0.4,
      ),
    ];
  }

  Widget _buildText(
      {required String text, required Offset position, required double width}) {
    return AbsolutePercentagePositioned(
      x: position.dx,
      y: position.dy,
      child: SizedBox(
        width: width,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildAddPhotoButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: 56),
        child: PhotoTakeButton(
          onClick: () {},
        ),
      ),
    );
  }

  Widget _buildGalleryButton() {
    return Positioned(
      left: 24,
      bottom: 24,
      child: AppIconButton(
        icon: Icon(Icons.image_outlined),
        onClick: () {},
      ),
    );
  }

  Widget _buildCopyFromClipboardButton() {
    return Positioned(
      right: 12,
      top: 76,
      child: AppIconButton(
        icon: Icon(Icons.content_paste_go_rounded),
        onClick: () {},
      ),
    );
  }
}
