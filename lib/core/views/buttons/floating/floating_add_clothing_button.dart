import 'package:flutter/material.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/utils/constants.dart';
import 'package:style_me/core/views/buttons/app_button.dart';
import 'package:style_me/core/views/ui_models/app_button_icon_data.dart';
import 'package:style_me/core/views/ui_models/icon_position.dart';

class FloatingAddClothingButton extends StatelessWidget {
  final Function() onClick;

  const FloatingAddClothingButton({
    super.key,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: localizations.floatingAddClothingButtonText,
      onClick: onClick,
      style: ElevatedButton.styleFrom(
          elevation: 4,
          shape: RoundedRectangleBorder(
              borderRadius: GlobalUiConst.borderRadiusLarge)),
      icon: AppButtonIconData.svg(
          "assets/apparel_icon.svg", IconPosition.leading),
    );
  }
}
