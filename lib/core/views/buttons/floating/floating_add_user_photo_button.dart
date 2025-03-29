import 'package:flutter/material.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/utils/constants.dart';
import 'package:style_me/core/views/buttons/app_button.dart';
import 'package:style_me/core/views/ui_models/app_button_icon_data.dart';
import 'package:style_me/core/views/ui_models/icon_position.dart';

class FloatingAddUserPhotoButton extends StatelessWidget {
  final Function() onClick;

  const FloatingAddUserPhotoButton({
    super.key,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: localizations.floatingAddUserPhotoButtonText,
      onClick: onClick,
      style: ElevatedButton.styleFrom(
        elevation: 4,
        shape: RoundedRectangleBorder(
            borderRadius: GlobalUiConst.borderRadiusLarge),
      ),
      icon: AppButtonIconData.iconData(
        Icons.accessibility_new_rounded,
        IconPosition.leading,
      ),
    );
  }
}
