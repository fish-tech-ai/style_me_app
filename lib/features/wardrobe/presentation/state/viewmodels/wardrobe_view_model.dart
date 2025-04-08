import 'dart:async';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/core/extensions/list_ext.dart';
import 'package:style_me/core/network/utils/image_process/image_fetcher.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/wardrobe/data/models/user_photos/user_photo.dart';
import 'package:style_me/features/wardrobe/domain/user_photo/get_user_photos_use_case.dart';
import 'package:style_me/features/wardrobe/presentation/state/states/wardrobe_state_holder.dart';
import 'package:style_me/features/wardrobe/presentation/ui_models/photo_with_action.dart';
import 'package:style_me/features/wardrobe/presentation/ui_models/modification_action_enum.dart';

part 'wardrobe_view_model.g.dart';

@riverpod
class WardrobeViewModel extends _$WardrobeViewModel {
  late final GetUserPhotosUseCase _getUserPhotosUseCase;
  late final ImageFetcher _multipleImageFetcher;

  WardrobeViewModel() {
    _getUserPhotosUseCase = getIt();
    _multipleImageFetcher = getIt<ImageFetcher>();
  }
  @override
  WardrobeStateHolder build() {
    Future.microtask(() => getUserPhotos());
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

  @visibleForTesting
  WardrobeViewModel.test(
    this._multipleImageFetcher,
    this._getUserPhotosUseCase,
  );
}
