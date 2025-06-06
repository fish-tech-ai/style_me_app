import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/views/animators/animated_visibility.dart';
import 'package:style_me/core/views/buttons/app_icon_button.dart';
import 'package:style_me/core/views/buttons/floating/floating_add_clothing_button.dart';
import 'package:style_me/core/views/buttons/floating/floating_add_user_photo_button.dart';
import 'package:style_me/features/auth/presentation/ui_models/anim_direction_enum.dart';

class AddPhotoMenuButton extends StatelessWidget {
  final bool isExpanded;
  final Function() onClicked;
  final Function() addClothingClicked;
  final Function() addUserPhotoClicked;

  const AddPhotoMenuButton({
    super.key,
    required this.isExpanded,
    required this.onClicked,
    required this.addClothingClicked,
    required this.addUserPhotoClicked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 6,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AnimatedVisibility(
          isVisible: isExpanded,
          animateAtFirstBuild: false,
          animDirection: AnimDirectionEnum.bottomToTop,
          duration: Duration(milliseconds: 300),
          child: _buildExpandableButtons(),
        ),
        AppIconButton(
          onClick: onClicked,
          padding: EdgeInsets.all(14),
          icon: Icon(
            Icons.add_rounded,
            color: context.colorScheme.onPrimary,
          ),
          elevation: 4,
        ),
      ],
    );
  }

  Widget _buildExpandableButtons() {
    return Column(
      spacing: 6,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingAddClothingButton(onClick: addClothingClicked),
        FloatingAddUserPhotoButton(onClick: addUserPhotoClicked),
      ],
    );
  }
}
