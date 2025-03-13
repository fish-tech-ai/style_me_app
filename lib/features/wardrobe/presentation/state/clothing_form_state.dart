import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:style_me/features/wardrobe/data/models/clothing_category_enum.dart';

part 'clothing_form_state.freezed.dart';

@freezed
class ClothingFormState with _$ClothingFormState {
  const factory ClothingFormState({
    @Default("") String nameText,
    @Default(ClothingCategoryEnum.ALL) ClothingCategoryEnum selectedCategory
  }) = _ClothingFormState;
}