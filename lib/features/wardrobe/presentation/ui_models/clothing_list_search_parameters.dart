import 'package:style_me/features/wardrobe/data/models/clothing/clothing_category_enum.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_position_enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'clothing_list_search_parameters.freezed.dart';

@freezed
class ClothingListSearchParameters with _$ClothingListSearchParameters {
  const factory ClothingListSearchParameters({
    @Default("") String searchText,
    ClothingPositionEnum? position,
    @Default(ClothingCategoryEnum.ALL) ClothingCategoryEnum category,
  }) = _ClothingListParameters;
}
