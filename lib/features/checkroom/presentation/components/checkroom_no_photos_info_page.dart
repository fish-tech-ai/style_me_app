import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/extensions/widget_ext.dart';
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
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 12,
        children: [
          Text(
            getTitleText(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "Add missing photos to access this page:",
            textAlign: TextAlign.center,
          ),
          FloatingAddClothingButton(
            onClick: () {
              context.push(AppPage.clothingAdd.path);
            },
          ).orEmpty(!isClothesEmpty),
          FloatingAddUserPhotoButton(
            onClick: () {
              context.push(AppPage.userPhotoAdd.path);
            },
          ).orEmpty(!isUserPhotosEmpty)
        ],
      ),
    );
  }

  String getTitleText() {
    final String missingPhotosText;
    if (isClothesEmpty && isUserPhotosEmpty) {
      missingPhotosText = "your and clothing";
    } else if (isUserPhotosEmpty) {
      missingPhotosText = "your";
    } else {
      missingPhotosText = "clothing";
    }
    return "It seems that you do not have $missingPhotosText photos";
  }
}
