import 'package:flutter/material.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/views/animators/animated_visibility.dart';
import 'package:style_me/core/views/containers/outlined_container.dart';
import 'package:style_me/core/views/input/app_checkbox.dart';
import 'package:style_me/core/views/input/app_text_field.dart';

class UserPhotoAddForm extends StatelessWidget {
  final bool isVisible;
  final String nameText;
  final bool isDefaultChecked;
  final Function(String) onNameTextChanged;
  final Function(bool) onIsDefaultChanged;

  const UserPhotoAddForm({
    super.key,
    required this.isVisible,
    required this.nameText,
    required this.onNameTextChanged,
    required this.onIsDefaultChanged,
    required this.isDefaultChecked,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedVisibility(
      isVisible: isVisible,
      size: Size.fromHeight(140),
      animateAtFirstBuild: false,
      child: OutlinedContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              text: nameText,
              labelText: localizations.nameLabel,
              onTextChanged: onNameTextChanged,
            ),
            AppCheckbox(
              value: isDefaultChecked,
              title: localizations.setAsDefault,
              onChanged: (isChecked) => onIsDefaultChanged(isChecked!),
            )
          ],
        ),
      ),
    );
  }
}
