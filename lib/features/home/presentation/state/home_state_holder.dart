import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:style_me/features/wardrobe/data/models/photo_item.dart';

part 'home_state_holder.freezed.dart';

@freezed
class HomeStateHolder with _$HomeStateHolder {
  const factory HomeStateHolder({
    @Default([]) List<PhotoItem> historyPhotos,
    @Default([]) List<PhotoItem> likedPhotos,
  }) = _HomeStateHolder;

}