import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/core/extensions/list_ext.dart';
import 'package:style_me/core/network/utils/image_process/image_fetcher.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/checkroom/presentation/state/checkroom_state_holder.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing.dart';
import 'package:style_me/features/wardrobe/data/models/user_photos/user_photo.dart';
import 'package:style_me/features/wardrobe/domain/user_photo/get_user_photos_use_case.dart';

part 'checkroom_view_model.g.dart';

@riverpod
class CheckroomViewModel extends _$CheckroomViewModel {
  late final GetUserPhotosUseCase _getUserPhotosUseCase;
  late final ImageFetcher _multipleImageFetcher;

  CheckroomViewModel() {
    _getUserPhotosUseCase = getIt();
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
    final convertedUserPhotos = userPhotosWithPaths.asUserPhotosList();

    state = state.copyWith(
      userPhotos: convertedUserPhotos,
      selectedUserPhoto: convertedUserPhotos.firstOrNull,
      isUserPhotosEmpty: convertedUserPhotos.isEmpty,
      isUserPhotosLoading: false,
    );
  }

  void onUserPhotoChange(UserPhoto userPhoto) {
    state = state.copyWith(selectedUserPhoto: userPhoto);
  }

  void onClothesLoaded(List<Clothing> clothes) {
    state = state.copyWith(
      isClothesLoading: false,
      isClothesEmpty: clothes.isEmpty,
      clothes: clothes,
    );
  }

  void onClothingSelected(Clothing selectedClothing) {



    //TODO we need to make function that will:
    // unselect all selected from current category
    // add selected to selectedClothes or replaces if already have particular category
    // show try on button if process is ready to go (selectedClothes are not empty

    state.selectedClothes.add(selectedClothing.copyWith());
    state = state.copyWith(selectedClothes: state.selectedClothes);
  }
}
