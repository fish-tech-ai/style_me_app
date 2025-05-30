import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/extensions/global_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/views/buttons/app_outlined_button.dart';
import 'package:style_me/core/views/custom/animated_arrow.dart';

class OnboardingStackPage extends StatelessWidget {
  final List<Widget> children;

  const OnboardingStackPage({super.key, required this.children});

  ///Simple page with [title], [subtitle] and [arrow] where [arrow] position is scaled to full screen size
  OnboardingStackPage.simple({
    super.key,
    required String title,
    required String subtitle,
    required Offset target,
    List<Widget> children = const [],
  }) : children = [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          ...children,
          AnimatedArrow(
            sourcePosition: Offset(0.48, 0.58),
            targetPosition: target,
          )
        ];

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: BackdropFilter(
        //TODO dev only comments, uncomment after all onboarding widgets will be ready
      filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),//6, sigmaY: 6),
        child: ColoredBox(
          color: context.customColors.backgroundA85,
          child: SafeArea(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                debugMessagePrint("ONBOARDING: CONTINUE");
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ...children,
                  Positioned(
                    right: 12,
                    left: 12,
                    bottom: 12,
                    child: buildTapToContinue(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTapToContinue() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppOutlinedButton(
          text: localizations.onboardingSkip,
          onClick: () {
            debugMessagePrint("ONBOARDING: SKIP TUTORIAL");
          },
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.touch_app_rounded),
            Text(
              localizations.onboardingContinue,
              style: TextStyle(),
            )
          ],
        ),
      ],
    );
  }
}
