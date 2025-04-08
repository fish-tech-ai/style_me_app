import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_category_enum.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_position_enum.dart';

part 'clothes_list_state.freezed.dart';

@freezed
class ClothesListState with _$ClothesListState {
  const factory ClothesListState({
    @Default([]) List<Clothing> clothes,
    @Default("") String searchText,
    ClothingPositionEnum? filterPosition,
    @Default(ClothingCategoryEnum.ALL) ClothingCategoryEnum filterCategory,
    @Default(true) bool isClothesLoading,
  }) = _ClothesListState;
}