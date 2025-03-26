import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:style_me/features/wardrobe/data/models/clothing.dart';

part 'edit_photo_state_holder.freezed.dart';

@freezed
class EditPhotoStateHolder with _$EditPhotoStateHolder {
  const factory EditPhotoStateHolder({
    @Default(false) bool isSaveLoading,
    @Default(false) bool isDeleteLoading,
    required Clothing clothing,
    @Default(false) bool isDefault,
  }) = _EditPhotoStateHolder;
}