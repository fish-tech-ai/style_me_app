import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/core/extensions/list_ext.dart';
import 'package:style_me/core/network/utils/image_process/image_fetcher.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_category_enum.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_position_enum.dart';
import 'package:style_me/features/wardrobe/data/models/user_photos/user_photo.dart';
import 'package:style_me/features/wardrobe/domain/clothing/get_clothes_use_case.dart';
import 'package:style_me/features/wardrobe/domain/user_photo/get_user_photos_use_case.dart';
import 'package:style_me/features/wardrobe/presentation/state/states/wardrobe_state_holder.dart';
import 'package:style_me/features/wardrobe/presentation/ui_models/photo_with_action.dart';
import 'package:style_me/features/wardrobe/presentation/ui_models/modification_action_enum.dart';

part 'wardrobe_view_model.g.dart';

@riverpod
class WardrobeViewModel extends _$WardrobeViewModel {
  late final GetClothesUseCase _getClothesUseCase;
  late final GetUserPhotosUseCase _getUserPhotosUseCase;
  late final ImageFetcher _multipleImageFetcher;

  WardrobeViewModel() {
    _getClothesUseCase = getIt();
    _getUserPhotosUseCase = getIt();
    _multipleImageFetcher = getIt<ImageFetcher>();
  }

  Timer? _spamTimer;

  @override
  WardrobeStateHolder build() {
    Future.microtask(() => getAllPhotos());
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

  void onUserPhotoModifyResult(PhotoWithAction userPhotoWithAction) {
    final UserPhoto modifiedUserPhoto = userPhotoWithAction.item as UserPhoto;
    switch (userPhotoWithAction.action) {
      case ModificationActionEnum.update:
        final updatedPhotos = state.userPhotos
            .getUpdatedWith(modifiedUserPhoto)
            .asUserPhotosList();
        state = state.copyWith(
            userPhotos: modifiedUserPhoto.isDefault
                ? updatedPhotos.withDefaultOn(modifiedUserPhoto)
                : updatedPhotos);
        break;
      case ModificationActionEnum.delete:
        state = state.copyWith(
          userPhotos: state.userPhotos
              .getReducedWith(userPhotoWithAction.item)
              .asUserPhotosList(),
        );
        break;
    }
  }

  Future getAllPhotos() async {
    getClothes();
    getUserPhotos();
  }

  Future getUserPhotos() async {
    state = state.copyWith(isUserPhotosLoading: true);
    final Result<List<UserPhoto>> result = await _getUserPhotosUseCase();
    result.collect(
      (userPhotos) {
        _convertUserImagesAndShow(userPhotos);
      },
      (failure) {
        ref.read(appGlobalViewModelProvider.notifier).showFailure(failure);
        state = state.copyWith(isUserPhotosLoading: false);
      },
    );
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

    state = state.copyWith(clothes: clothesWithPaths, isClothesLoading: false);
  }

  void _convertUserImagesAndShow(List<UserPhoto> userPhotosWithUrls) async {
    final cacheDir = await getTemporaryDirectory();
    final List<UserPhoto> userPhotosWithPaths = userPhotosWithUrls.map(
      (userPhoto) {
        return userPhoto.copyWith(
            image: '${cacheDir.path}/${userPhoto.id}.webp');
      },
    ).toList();
    await _fetchAndDecryptImageFromIsolate(
      userPhotosWithUrls
          .map((userPhotoWithUrl) => userPhotoWithUrl.image)
          .toList(),
      userPhotosWithPaths
          .map((userPhotoWithPath) => userPhotoWithPath.image)
          .toList(),
    );

    state = state.copyWith(
        userPhotos: userPhotosWithPaths, isUserPhotosLoading: false);
  }

  Future _fetchAndDecryptImageFromIsolate(
      List<String> urls, List<String> paths) async {
    await _multipleImageFetcher.handleImagesLoadingAndCache(urls, paths);
  }

  @visibleForTesting
  WardrobeViewModel.test(
    this._getClothesUseCase,
    this._multipleImageFetcher,
    this._getUserPhotosUseCase,
  );
}
