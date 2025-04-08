import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:style_me/features/wardrobe/data/models/user_photos/user_photo.dart';

part 'wardrobe_state_holder.freezed.dart';

@freezed
class WardrobeStateHolder with _$WardrobeStateHolder {
  const factory WardrobeStateHolder({
    @Default([]) List<UserPhoto> userPhotos,
    @Default(true) bool isUserPhotosLoading,
  }) = _WardrobeStateHolder;
}
