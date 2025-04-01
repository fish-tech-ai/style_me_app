import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_category_enum.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_position_enum.dart';
import 'package:style_me/features/wardrobe/data/models/photo_item.dart';

part 'wardrobe_state_holder.freezed.dart';

@freezed
class WardrobeStateHolder with _$WardrobeStateHolder {
  const factory WardrobeStateHolder({
    @Default([]) List<Clothing> clothes,
    @Default([]) List<PhotoItem> userPhotos,
    @Default("") String searchText,
    ClothingPositionEnum? filterPosition,
    @Default(ClothingCategoryEnum.ALL) ClothingCategoryEnum filterCategory,
    @Default(true) bool isLoading,
  }) = _WardrobeStateHolder;
}