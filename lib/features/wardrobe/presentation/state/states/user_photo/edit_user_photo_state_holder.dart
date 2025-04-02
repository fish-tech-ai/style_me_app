import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:style_me/features/wardrobe/data/models/user_photos/user_photo.dart';

part 'edit_user_photo_state_holder.freezed.dart';

@freezed
class EditUserPhotoStateHolder with _$EditUserPhotoStateHolder {
  const factory EditUserPhotoStateHolder({
    @Default(false) bool isSaveLoading,
    @Default(false) bool isDeleteLoading,
    @Default(true) bool isPageLoading,
    @Default("") String originalImagePath,
    required UserPhoto userPhoto,
    @Default(false) bool isDefault,
  }) = _EditUserPhotoStateHolder;
}