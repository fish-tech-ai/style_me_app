import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:style_me/features/home/data/models/outfit.dart';

part 'outfit_details_state_holder.freezed.dart';

@freezed
sealed class OutfitDetailsStateHolder with _$OutfitDetailsStateHolder {
  const factory OutfitDetailsStateHolder({
    required Outfit outfit,
    @Default(false) bool isFavorite,
    @Default(false) bool isDownloading,
    @Default(false) bool isNoPermissionSnackBarVisible,
  }) = _OutfitDetailsStateHolder;

}