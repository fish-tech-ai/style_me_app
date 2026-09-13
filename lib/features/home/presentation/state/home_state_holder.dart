import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:style_me/features/home/data/models/outfit.dart';

part 'home_state_holder.freezed.dart';

@freezed
sealed class HomeStateHolder with _$HomeStateHolder {
  const HomeStateHolder._();

  const factory HomeStateHolder({
    @Default([]) List<Outfit> recentPhotos,
    @Default([]) List<Outfit> favorites,
    @Default("") String userName,
  }) = _HomeStateHolder;

  bool noOutfitsAvailable() => recentPhotos.isEmpty && favorites.isEmpty;
}
