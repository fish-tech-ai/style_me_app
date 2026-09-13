import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:style_me/features/home/data/models/outfit.dart';

part 'home_grid_list_state_holder.freezed.dart';

@freezed
sealed class HomeGridListStateHolder with _$HomeGridListStateHolder {
  const factory HomeGridListStateHolder({
    @Default([]) List<Outfit> outfits,
    @Default(false) bool isNoPermissionSnackBarVisible,
    @Default(false) bool isDownloading,
  }) = _HomeGridListStateHolder;
}