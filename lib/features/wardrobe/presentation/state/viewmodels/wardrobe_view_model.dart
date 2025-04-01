import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/core/extensions/list_ext.dart';
import 'package:style_me/core/network/utils/image_process/multiple_image_fetcher.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_category_enum.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_position_enum.dart';
import 'package:style_me/features/wardrobe/domain/clothing/get_clothes_use_case.dart';
import 'package:style_me/features/wardrobe/presentation/state/wardrobe_state_holder.dart';
import 'package:style_me/features/wardrobe/presentation/ui_models/clothing_with_action.dart';
import 'package:style_me/features/wardrobe/presentation/ui_models/modification_action_enum.dart';

part 'wardrobe_view_model.g.dart';

@riverpod
class WardrobeViewModel extends _$WardrobeViewModel {
  late final GetClothesUseCase _getClothesUseCase;
  late final MultipleImageFetcher _multipleImageFetcher;

  WardrobeViewModel() {
    _getClothesUseCase = getIt();
    _multipleImageFetcher = getIt<MultipleImageFetcher>();
  }

  Timer? _spamTimer;

  @override
  WardrobeStateHolder build() {
    Future.microtask(() => getClothes());
    return WardrobeStateHolder();
  }

  void clearFilters() {
    state = state.copyWith(
      filterPosition: null,
      filterCategory: ClothingCategoryEnum.ALL,
    );
    getClothes();
  }

  void onSearchTextChanged(String text) {
    state = state.copyWith(searchText: text);
    getClothes();
  }

  void onFilterChanged(ClothingPositionEnum? clothingPosition,
      ClothingCategoryEnum clothingCategory) {
    state = state.copyWith(
      filterPosition: clothingPosition,
      filterCategory: clothingCategory,
    );
    getClothes();
  }

  void onClothingModifyResult(ClothingWithAction clothingWithAction) {
    switch (clothingWithAction.action) {
      case ModificationActionEnum.update:
        state = state.copyWith(
          clothes: state.clothes
              .getUpdatedWith(clothingWithAction.clothing)
              .asClothingList(),
        );
        break;
      case ModificationActionEnum.delete:
        state = state.copyWith(
          clothes: state.clothes
              .getReducedWith(clothingWithAction.clothing)
              .asClothingList(),
        );
        break;
    }
  }

  Future getClothes() async {
    state = state.copyWith(isLoading: true);
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
        _convertImagesAndShow(clothes);
      },
      (failure) {
        ref.read(appGlobalViewModelProvider.notifier).showFailure(failure);
        state = state.copyWith(isLoading: false);
      },
    );
  }

  void _convertImagesAndShow(List<Clothing> clothesWithUrls) async {
    final cacheDir = await getTemporaryDirectory();
    final List<Clothing> clothesWithPaths = clothesWithUrls.map(
      (clothing) {
        return clothing.copyWith(image: '${cacheDir.path}/${clothing.id}.webp');
      },
    ).toList();
    await _fetchAndDecryptImageFromIsolate(
      clothesWithUrls.map((clothingWithUrl) => clothingWithUrl.image).toList(),
      clothesWithPaths
          .map((clothingWithPath) => clothingWithPath.image)
          .toList(),
    );

    state = state.copyWith(clothes: clothesWithPaths, isLoading: false);
  }

  Future _fetchAndDecryptImageFromIsolate(
      List<String> urls, List<String> paths) async {
    await _multipleImageFetcher.handleImagesLoadingAndCache(urls, paths);
  }

  @visibleForTesting
  WardrobeViewModel.test(this._getClothesUseCase, this._multipleImageFetcher);
}
