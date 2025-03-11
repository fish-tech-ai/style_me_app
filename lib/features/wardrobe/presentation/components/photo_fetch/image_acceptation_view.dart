import 'dart:io';

import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/views/buttons/app_button.dart';
import 'package:style_me/core/views/buttons/app_outlined_button.dart';

class ImageAcceptationView extends StatelessWidget {
  final File imageFile;
  final bool shouldFlip;
  final Function() onTryAgainClicked;
  final Function() onAcceptClicked;

  const ImageAcceptationView({
    super.key,
    required this.imageFile,
    required this.onTryAgainClicked,
    required this.onAcceptClicked,
    required this.shouldFlip,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Transform.flip(flipX: shouldFlip, child: Image.file(imageFile)),
          Positioned(
            left: 12,
            bottom: 12,
            child: AppOutlinedButton(
              text: localizations.tryAgain,
              width: 120,
              style: OutlinedButton.styleFrom(
                  backgroundColor: context.colorScheme.secondary),
              onClick: onTryAgainClicked,
            ),
          ),
          Positioned(
            right: 12,
            bottom: 12,
            child: AppButton(
              text: localizations.continueText,
              width: 120,
              onClick: onAcceptClicked,
            ),
          )
        ],
      ),
    );
  }
}
