import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/features/wardrobe/data/models/clothing.dart';
import 'package:style_me/features/wardrobe/data/models/clothing_category_enum.dart';
import 'package:style_me/features/wardrobe/data/models/clothing_position_enum.dart';
import 'package:style_me/features/wardrobe/domain/delete_clothing_use_case.dart';
import 'package:style_me/features/wardrobe/domain/update_clothing_use_case.dart';
import 'package:style_me/features/wardrobe/presentation/state/edit_photo_state_holder.dart';

part 'edit_photo_view_model.g.dart';

@riverpod
class EditPhotoViewModel extends _$EditPhotoViewModel {
  late final DeleteClothingUseCase _deleteClothingUseCase;
  late final UpdateClothingUseCase _updateClothingUseCase;

  EditPhotoViewModel() {
    _deleteClothingUseCase = getIt();
    _updateClothingUseCase = getIt();
  }

  @override
  EditPhotoStateHolder build() {
    return EditPhotoStateHolder(
      clothing: Clothing(
        "",
        "",
        "",
        ClothingCategoryEnum.ALL,
        ClothingPositionEnum.BOTTOM,
      ),
    );
  }

  void init(Clothing clothing) {
    state = state.copyWith(clothing: clothing);
  }

  Future deleteClothing(Function() onSuccess) async {
    state = state.copyWith(isDeleteLoading: true);
    final result = await _deleteClothingUseCase(state.clothing.image);
    result.collect((_) {
      onSuccess();
    }, (failure) {
      ref.read(appGlobalViewModelProvider.notifier).showFailure(failure);
    });
    state = state.copyWith(isDeleteLoading: false);
  }

  Future updateClothing(Function(Clothing) onSuccess) async {
    state = state.copyWith(isSaveLoading: true);
    final result = await _updateClothingUseCase(
        state.clothing.id, state.clothing.name, state.clothing.category);
    result.collect((_) {
      onSuccess(state.clothing);
    }, (failure) {
      ref.read(appGlobalViewModelProvider.notifier).showFailure(failure);
    });
    state = state.copyWith(isSaveLoading: false);
  }

  void onNameTextChanged(String text) {
    state = state.copyWith(clothing: state.clothing.copyWith(name: text));
  }

  void onCategorySelected(ClothingCategoryEnum category) {
    state =
        state.copyWith(clothing: state.clothing.copyWith(category: category));
  }
}
