import 'package:flutter/material.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/views/animators/animated_visibility.dart';
import 'package:style_me/core/views/containers/outlined_container.dart';
import 'package:style_me/core/views/input/dropdowns/app_dropdown_button.dart';
import 'package:style_me/core/views/input/app_text_field.dart';
import 'package:style_me/features/wardrobe/data/models/clothing_category_enum.dart';

class ClothingPhotoAddForm extends StatelessWidget {
  final bool isVisible;
  final String nameText;
  final ClothingCategoryEnum category;
  final bool isRecommendedCategory;
  final Function(String) onNameTextChanged;
  final Function(ClothingCategoryEnum) onCategorySelected;

  const ClothingPhotoAddForm({
    super.key,
    required this.isVisible,
    required this.nameText,
    required this.category,
    required this.onNameTextChanged,
    required this.onCategorySelected,
    this.isRecommendedCategory = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedVisibility(
      isVisible: isVisible,
      size: Size.fromHeight(186),
      animateAtFirstBuild: false,
      child: OutlinedContainer(
        child: Column(
          children: [
            AppTextField(
                text: nameText,
                labelText: localizations.nameLabel,
                onTextChanged: onNameTextChanged),
            AppDropdownButton(
              items: ClothingCategoryEnum.withoutAllCategory(),
              selectedItem: category,
              itemBuilder: (item) => Center(child: Text(item.text)),
              onItemSelect: onCategorySelected,
              labelText: (isRecommendedCategory
                  ? "${localizations.category} ${localizations.recommendedLabel}"
                  : localizations.category),
            )
          ],
        ),
      ),
    );
  }
}
