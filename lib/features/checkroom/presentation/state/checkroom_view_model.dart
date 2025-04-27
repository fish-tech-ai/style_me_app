import 'dart:async';

import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/core/extensions/list_ext.dart';
import 'package:style_me/core/network/utils/image_process/image_fetcher.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/checkroom/presentation/state/checkroom_state_holder.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing.dart';
import 'package:style_me/features/wardrobe/data/models/photo_item.dart';
import 'package:style_me/features/wardrobe/data/models/user_photos/user_photo.dart';

import '../../domain/get_user_original_photos_use_case.dart';

part 'checkroom_view_model.g.dart';

@riverpod
class CheckroomViewModel extends _$CheckroomViewModel {
  late final GetUserOriginalPhotosUseCase _getUserOriginalPhotosUseCase;
  late final ImageFetcher _multipleImageFetcher;

  CheckroomViewModel() {
    _getUserOriginalPhotosUseCase = getIt();
    _multipleImageFetcher = getIt();
  }

  @override
  CheckroomStateHolder build() {
    Future.microtask(() {
      getUserPhotos();
    });
    return CheckroomStateHolder();
  }

  Future getUserPhotos() async {
    state = state.copyWith(isUserPhotosLoading: true);
    final Result<List<UserPhoto>> result =
        await _getUserOriginalPhotosUseCase();
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
    final convertedUserPhotos = userPhotosWithPaths.asUserPhotosList();

    state = state.copyWith(
      userPhotos: convertedUserPhotos,
      selectedUserPhoto: convertedUserPhotos.firstOrNull,
      isUserPhotosEmpty: convertedUserPhotos.isEmpty,
      isUserPhotosLoading: false,
    );
  }

  void onUserPhotoChange(PhotoItem userPhoto) {
    state = state.copyWith(selectedUserPhoto: userPhoto as UserPhoto);
  }

  void onClothesLoaded(List<Clothing> clothes) {
    state = state.copyWith(
      isClothesLoading: false,
      isClothesEmpty: clothes.isEmpty,
    );
    _setClothesWithSelection(clothes, state.selectedClothes);
  }

  void onClothingSelected(Clothing selectedClothing) {
    List<Clothing> updatedSelectedClothes =
        List<Clothing>.from(state.selectedClothes);

    if (selectedClothing.isSelected) {
      updatedSelectedClothes
          .removeWhere((clothing) => clothing.id == selectedClothing.id);
    } else {
      updatedSelectedClothes
        ..removeWhere(
            (clothing) => clothing.position == selectedClothing.position)
        ..add(selectedClothing);
    }
    _setClothesWithSelection(state.clothes, updatedSelectedClothes);
  }

  void _setClothesWithSelection(
      List<Clothing> allClothes, List<Clothing> selectedClothes) {
    final List<Clothing> newClothes = allClothes.map((photo) {
      final Clothing? selectedClothing = selectedClothes
          .firstWhereOrNull((clothing) => clothing.id == photo.id);
      if (selectedClothing != null) {
        return photo.copyWith(isSelected: true);
      }
      return photo.copyWith(isSelected: false);
    }).toList();

    state =
        state.copyWith(clothes: newClothes, selectedClothes: selectedClothes);
  }
}
