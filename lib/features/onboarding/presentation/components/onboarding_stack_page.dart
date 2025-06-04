import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/extensions/widget_ext.dart';
import 'package:style_me/core/extensions/widget_ref_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/views/buttons/app_outlined_button.dart';
import 'package:style_me/core/views/custom/animated_arrow.dart';

class OnboardingStackPage extends ConsumerWidget {
  final List<Widget> children;
  final EdgeInsets? margin;
  final bool isControlsPositionTop;

  /// if null then continue label will not appear
  final Function()? onContinueClicked;

  const OnboardingStackPage(
      {super.key, required this.children, this.onContinueClicked, this.margin, this.isControlsPositionTop = false});

  ///Simple page with [title], [subtitle] and [arrow] where [arrow] position is scaled to full screen size
  OnboardingStackPage.simple({
    super.key,
    required String title,
    required String subtitle,
    Offset? target,
    Offset source = const Offset(0.48, 0.58),
    List<Widget> children = const [],
    this.onContinueClicked,
    this.margin,
    this.isControlsPositionTop = false
  }) : children = [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          ...children,
          AnimatedArrow(
            sourcePosition: source,
            targetPosition: target ?? Offset.zero,
          ).orEmpty(target == null)
        ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        type: MaterialType.transparency,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: ColoredBox(
            color: context.customColors.backgroundA85,
            child: SafeArea(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  onContinueClicked?.call();
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ...children,
                    Positioned(
                      right: 12,
                      left: 12,
                      bottom: isControlsPositionTop ? null : 12,
                      top: isControlsPositionTop ? 12 : null,
                      child: buildOnboardingControls(ref),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildOnboardingControls(WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppOutlinedButton(
          text: localizations.onboardingSkip,
          onClick: () {
            ref.globalViewModel.onboardingStop();
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
        ).orEmpty(onContinueClicked == null),
      ],
    );
  }
}
