import 'package:flutter/material.dart';
import 'package:style_me/core/views/animators/animated_visibility.dart';
import 'package:style_me/features/wardrobe/data/models/clothing_category_enum.dart';

class ClothingPhotoAddForm extends StatelessWidget {
  final bool isVisible;
  final String nameText;
  final ClothingCategoryEnum category;
  final Function(String) onNameTextChanged;
  final Function(ClothingCategoryEnum) onCategorySelected;

  const ClothingPhotoAddForm({
    super.key,
    required this.isVisible,
    required this.nameText,
    required this.category,
    required this.onNameTextChanged,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedVisibility(
      isVisible: isVisible,
      size: Size.fromHeight(100),
      animateAtFirstBuild: false,
      child: SizedBox(), //TODO
    );
  }
}
