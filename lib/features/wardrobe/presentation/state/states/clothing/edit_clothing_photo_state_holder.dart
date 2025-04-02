import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing.dart';

part 'edit_clothing_photo_state_holder.freezed.dart';

@freezed
class EditClothingPhotoStateHolder with _$EditClothingPhotoStateHolder {
  const factory EditClothingPhotoStateHolder({
    @Default(false) bool isSaveLoading,
    @Default(false) bool isDeleteLoading,
    @Default(true) bool isPageLoading,
    @Default("") String originalImagePath,
    required Clothing clothing,
    @Default(false) bool isDefault,
  }) = _EditClothingPhotoStateHolder;
}