import 'dart:io';

import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/views/buttons/app_button.dart';
import 'package:style_me/core/views/buttons/app_outlined_button.dart';

class ImageAcceptationView extends StatelessWidget {
  final File imageFile;
  final Function() onTryAgainClicked;
  final Function() onAcceptClicked;
  final bool isImageAddLoading;
  final String actionButtonText;
  final Widget imageDataForm;

  const ImageAcceptationView({
    super.key,
    required this.imageFile,
    required this.onTryAgainClicked,
    required this.onAcceptClicked,
    required this.imageDataForm,
    this.isImageAddLoading = false,
    required this.actionButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Image.file(
            imageFile,
            fit: BoxFit.fitWidth,
          ),
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
              text: actionButtonText,
              width: 120,
              isLoading: isImageAddLoading,
              onClick: onAcceptClicked,
            ),
          ),
          Positioned.fill(
            child: Align(alignment: Alignment.center, child: imageDataForm),
          ),
        ],
      ),
    );
  }
}
