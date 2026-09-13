import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:style_me/core/network/exceptions/helpers/image_error_type/image_type_enum.dart';
import 'package:style_me/features/wardrobe/data/models/photo_target_enum.dart';
import 'package:style_me/features/wardrobe/presentation/state/states/user_photo/user_photo_form_state.dart';
import 'package:style_me/features/wardrobe/presentation/ui_models/add_photo_page_mode.dart';

part 'add_user_photo_state_holder.freezed.dart';

@freezed
sealed class AddUserPhotoStateHolder with _$AddUserPhotoStateHolder {
  const factory AddUserPhotoStateHolder({
    File? image,
    @Default(false) bool isImageAddLoading,
    ImageErrorTypeEnum? imageProcessingError,
    @Default(AddPhotoPageMode.pickPhoto) AddPhotoPageMode addPhotoPageMode,
    @Default(UserPhotoFormState()) UserPhotoFormState userPhotoForm,
    @Default(true) shouldDeletePhoto,
    @Default(PhotoTargetEnum.clothes) target,
  }) = _AddUserPhotoStateHolder;
}
