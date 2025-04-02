import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:style_me/core/network/exceptions/helpers/image_error_type/image_type_enum.dart';
import 'package:style_me/features/wardrobe/data/models/photo_target_enum.dart';
import 'package:style_me/features/wardrobe/presentation/state/states/clothing/clothing_form_state.dart';
import 'package:style_me/features/wardrobe/presentation/ui_models/add_photo_page_mode.dart';

part 'add_clothing_photo_state_holder.freezed.dart';

@freezed
class AddClothingPhotoStateHolder with _$AddClothingPhotoStateHolder {
  const factory AddClothingPhotoStateHolder({
    File? image,
    @Default(false) bool isImageAddLoading,
    ImageErrorTypeEnum? imageProcessingError,
    @Default(AddPhotoPageMode.pickPhoto) AddPhotoPageMode addPhotoPageMode,
    @Default(ClothingFormState()) ClothingFormState clothingForm,
    @Default(true) shouldDeletePhoto,
    @Default(PhotoTargetEnum.clothes) target,
  }) = _AddClothingPhotoStateHolder;
}
