import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/extensions/widget_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/navigation/app_page.dart';
import 'package:style_me/core/views/buttons/floating/floating_add_clothing_button.dart';
import 'package:style_me/core/views/buttons/floating/floating_add_user_photo_button.dart';

class CheckroomNoPhotosInfoPage extends StatelessWidget {
  final bool isClothesEmpty;
  final bool isUserPhotosEmpty;

  const CheckroomNoPhotosInfoPage({
    super.key,
    required this.isClothesEmpty,
    required this.isUserPhotosEmpty,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.customColors.backgroundA85,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 12,
        children: [
          SizedBox(height: 62),
          Column(
            spacing: 6,
            children: [
              Text(
                "Missing photos",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                getTitleText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Column(
            spacing: 6,
            children: [
              FloatingAddClothingButton(
                onClick: () {
                  context.push(AppPage.clothingAdd.path);
                },
              ).orEmpty(!isClothesEmpty),
              FloatingAddUserPhotoButton(
                onClick: () {
                  context.push(AppPage.userPhotoAdd.path);
                },
              ).orEmpty(!isUserPhotosEmpty),
            ],
          )
        ],
      ),
    );
  }

  String getTitleText() {
    final String missingPhotosText;
    if (isClothesEmpty && isUserPhotosEmpty) {
      missingPhotosText = localizations.missingPostureAndClothing;
    } else if (isUserPhotosEmpty) {
      missingPhotosText = localizations.missingPosture;
    } else {
      missingPhotosText = localizations.missingClothing;
    }
    return missingPhotosText;
  }
}
