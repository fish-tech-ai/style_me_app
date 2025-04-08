import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:style_me/features/wardrobe/presentation/state/states/clothing/clothes_list_state.dart';

part 'checkroom_state_holder.freezed.dart';

@freezed
class CheckroomStateHolder with _$CheckroomStateHolder {
  const factory CheckroomStateHolder({
    @Default(ClothesListState()) ClothesListState clothesListState,
  }) = _CheckroomStateHolder;
}
