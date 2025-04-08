import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/core/extensions/list_ext.dart';
import 'package:style_me/core/network/utils/image_process/image_fetcher.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_category_enum.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_position_enum.dart';
import 'package:style_me/features/wardrobe/domain/clothing/get_clothes_use_case.dart';
import 'package:style_me/features/wardrobe/presentation/state/states/clothing/clothes_list_state.dart';
import 'package:style_me/features/wardrobe/presentation/ui_models/modification_action_enum.dart';
import 'package:style_me/features/wardrobe/presentation/ui_models/photo_with_action.dart';

part 'clothes_list_view_model.g.dart';

@riverpod
class ClothesListViewModel extends _$ClothesListViewModel {
  late final GetClothesUseCase _getClothesUseCase;
  late final ImageFetcher _multipleImageFetcher;

  ClothesListViewModel() {
    _getClothesUseCase = getIt();
    _multipleImageFetcher = getIt();
  }

  Timer? _spamTimer;

  @override
  ClothesListState build() {
    Future.microtask(() => getClothes());
    return ClothesListState();
  }

  Future getClothes() async {
    state = state.copyWith(isClothesLoading: true);
    _spamTimer?.cancel();
    _spamTimer = Timer(Duration(seconds: 1), () => _performGetClothes());
  }

  Future _performGetClothes() async {
    final Result<List<Clothing>> result = await _getClothesUseCase(
      state.searchText,
      state.filterPosition,
      state.filterCategory,
    );
    result.collect(
      (clothes) {
        _convertClothingImagesAndShow(clothes);
      },
      (failure) {
        ref.read(appGlobalViewModelProvider.notifier).showFailure(failure);
        state = state.copyWith(isClothesLoading: false);
      },
    );
  }

  void _convertClothingImagesAndShow(List<Clothing> clothesWithUrls) async {
    final clothesWithPaths =
        await _multipleImageFetcher.downloadImagesToCachePaths(clothesWithUrls);

    state = state.copyWith(
      clothes: clothesWithPaths.asClothingList(),
      isClothesLoading: false,
    );
  }

  void clearFilters() {
    state = state.copyWith(
      filterPosition: null,
      filterCategory: ClothingCategoryEnum.ALL,
    );
    getClothes();
  }

  void onSearchTextChanged(String text) {
    state = state.copyWith(
      searchText: text,
    );
    getClothes();
  }

  void onFiltersChanged(
    ClothingPositionEnum? clothingPosition,
    ClothingCategoryEnum clothingCategory,
  ) {
    state = state.copyWith(
      filterPosition: clothingPosition,
      filterCategory: clothingCategory,
    );
    getClothes();
  }

  void onClothingModifyResult(PhotoWithAction clothingWithAction) {
    switch (clothingWithAction.action) {
      case ModificationActionEnum.update:
        state = state.copyWith(
          clothes: state.clothes
              .getUpdatedWith(clothingWithAction.item)
              .asClothingList(),
        );
        break;
      case ModificationActionEnum.delete:
        state = state.copyWith(
          clothes: state.clothes
              .getReducedWith(clothingWithAction.item)
              .asClothingList(),
        );
        break;
    }
  }

  ClothesListViewModel.test(
    this._getClothesUseCase,
    this._multipleImageFetcher,
  );
}
