import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/core/network/utils/image_process/image_fetcher.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_category_enum.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_position_enum.dart';
import 'package:style_me/features/wardrobe/data/models/io/original_image_response.dart';
import 'package:style_me/features/wardrobe/domain/clothing/delete_clothing_use_case.dart';
import 'package:style_me/features/wardrobe/domain/clothing/update_clothing_use_case.dart';
import 'package:style_me/features/wardrobe/domain/clothing/get_original_clothing_image_url_use_case.dart';
import 'package:style_me/features/wardrobe/presentation/state/states/clothing/edit_clothing_photo_state_holder.dart';

part 'edit_clothing_photo_view_model.g.dart';

@riverpod
class EditClothingPhotoViewModel extends _$EditClothingPhotoViewModel {
  late final DeleteClothingUseCase _deleteClothingUseCase;
  late final UpdateClothingUseCase _updateClothingUseCase;
  late final GetOriginalClothingImageUrlUseCase _getOriginalImageUrlUseCase;
  late final ImageFetcher _multipleImageFetcher;

  EditClothingPhotoViewModel() {
    _deleteClothingUseCase = getIt();
    _updateClothingUseCase = getIt();
    _getOriginalImageUrlUseCase = getIt();
    _multipleImageFetcher = getIt();
  }

  @override
  EditClothingPhotoStateHolder build() {
    return EditClothingPhotoStateHolder(
      clothing: Clothing(
        "",
        "",
        "",
        ClothingCategoryEnum.ALL,
        ClothingPositionEnum.BOTTOM,
      ),
    );
  }

  Future init(Clothing clothing) async {
    state = state.copyWith(clothing: clothing, isPageLoading: true);

    final Result<OriginalImageUrlResponse> result =
        await _getOriginalImageUrlUseCase(clothing.id);

    final cacheDir = await getTemporaryDirectory();
    result.collect((data) async {
      final String originalImagePath =
          '${cacheDir.path}/${clothing.id}_original.webp';
      await _multipleImageFetcher.handleSingleImageLoadingAndCache(
          data.signedUrl, originalImagePath);

      state = state.copyWith(
          clothing: clothing,
          originalImagePath: originalImagePath,
          isPageLoading: false);
    }, (failure) {
      ref.read(appGlobalViewModelProvider.notifier).showFailure(failure);
      state = state.copyWith(isPageLoading: false);
    });
  }

  Future deleteClothing(Function() onSuccess) async {
    state = state.copyWith(isDeleteLoading: true);
    final result = await _deleteClothingUseCase(state.clothing.id);
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

  EditClothingPhotoViewModel.test(
    this._deleteClothingUseCase,
    this._updateClothingUseCase,
    this._getOriginalImageUrlUseCase,
    this._multipleImageFetcher,
  );
}
