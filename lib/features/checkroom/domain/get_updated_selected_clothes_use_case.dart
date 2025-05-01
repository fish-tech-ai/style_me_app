import 'package:style_me/features/wardrobe/data/models/clothing/clothing.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_position_enum.dart';

/// This use case manage how clothes are selected/unselected based on following rules:
///
/// - if selected clothing is already selected - deselect
/// - if selected clothing is FullBody position - deselect all other clothes and select chosen
/// - if selected clothing is Upper or bottom position:
///   - if there is clothing selected with same position - replace
///   - if there is FullBody clothing selected - remove
class GetUpdatedSelectedClothesUseCase {
  List<Clothing> call(
    List<Clothing> currentSelectedClothes,
    Clothing selectedClothing,
  ) {
    List<Clothing> updatedSelectedClothes =
        List<Clothing>.from(currentSelectedClothes);
    if (selectedClothing.isSelected) {
      updatedSelectedClothes._getUnselectedById(selectedClothing.id);
    } else {
      updatedSelectedClothes._getSelected(selectedClothing);
    }
    return updatedSelectedClothes;
  }
}

extension on List<Clothing> {
  List<Clothing> _getUnselectedById(
    String selectedClothingId,
  ) {
    return this..removeWhere((clothing) => clothing.id == selectedClothingId);
  }

  List<Clothing> _getSelected(Clothing selectedClothing) {
    if (selectedClothing.position == ClothingPositionEnum.FULL_BODY) {
      return _replaceAllSelectedWith(selectedClothing);
    } else {
      return _replaceSelectedFullBodyAndSamePositionWith(selectedClothing);
    }
  }

  List<Clothing> _replaceAllSelectedWith(Clothing selectedClothing) {
    return this
      ..clear()
      ..add(selectedClothing);
  }

  List<Clothing> _replaceSelectedFullBodyAndSamePositionWith(
      Clothing selectedClothing) {
    return this
      ..removeWhere(
        (clothing) =>
            clothing.position == selectedClothing.position ||
            clothing.position == ClothingPositionEnum.FULL_BODY,
      )
      ..add(selectedClothing);
  }
}
