import 'dart:async';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/core/extensions/list_ext.dart';
import 'package:style_me/core/network/utils/image_process/image_fetcher.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing.dart';
import 'package:style_me/features/wardrobe/data/models/photo_item.dart';
import 'package:style_me/features/wardrobe/data/models/user_photos/user_photo.dart';
import 'package:style_me/features/wardrobe/domain/clothing/get_clothes_use_case.dart';
import 'package:style_me/features/wardrobe/domain/user_photo/get_user_photos_use_case.dart';
import 'package:style_me/features/wardrobe/presentation/state/states/wardrobe_state_holder.dart';
import 'package:style_me/features/wardrobe/presentation/ui_models/clothing_list_search_parameters.dart';
import 'package:style_me/features/wardrobe/presentation/ui_models/photo_with_action.dart';
import 'package:style_me/features/wardrobe/presentation/ui_models/modification_action_enum.dart';

part 'wardrobe_view_model.g.dart';

@riverpod
class WardrobeViewModel extends _$WardrobeViewModel {
  late final GetUserPhotosUseCase _getUserPhotosUseCase;
  late final GetClothesUseCase _getClothesUseCase;
  late final ImageFetcher _multipleImageFetcher;

  WardrobeViewModel() {
    _getUserPhotosUseCase = getIt();
    _getClothesUseCase = getIt();
    _multipleImageFetcher = getIt<ImageFetcher>();
  }
  @override
  WardrobeStateHolder build() {
    Future.microtask(() {
      getUserPhotos();
      getClothes(ClothingListSearchParameters());
    });
    return WardrobeStateHolder();
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

  void _convertUserImagesAndShow(List<UserPhoto> userPhotosWithUrls) async {
    final userPhotosWithPaths = await _multipleImageFetcher
        .downloadImagesToCachePaths(userPhotosWithUrls);

    state = state.copyWith(
      userPhotos: userPhotosWithPaths.asUserPhotosList(),
      isUserPhotosLoading: false,
    );
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

  /// clothing list handling
  Timer? _spamTimer;

  Future getClothes(ClothingListSearchParameters searchParameters) async {
    state = state.copyWith(isClothesLoading: true);
    _spamTimer?.cancel();
    _spamTimer = Timer(Duration(seconds: 1), () => _performGetClothes(searchParameters));
  }

  Future _performGetClothes(ClothingListSearchParameters searchParameters) async {
    final Result<List<Clothing>> result = await _getClothesUseCase(
      searchParameters.searchText,
      searchParameters.position,
      searchParameters.category,
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
    final List<PhotoItem> clothesWithPaths =
    await _multipleImageFetcher.downloadImagesToCachePaths(clothesWithUrls);

    final List<Clothing> convertedClothes = clothesWithPaths.asClothingList();
    state = state.copyWith(
      clothes: convertedClothes,
      isClothesLoading: false,
    );
  }

  void onSearchParametersChanged(ClothingListSearchParameters searchParameters) {
    getClothes(searchParameters);
  }

  @visibleForTesting
  WardrobeViewModel.test(
    this._multipleImageFetcher,
    this._getUserPhotosUseCase,
    this._getClothesUseCase,
  );
}
