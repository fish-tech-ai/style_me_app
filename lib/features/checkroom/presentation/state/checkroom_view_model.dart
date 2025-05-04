import 'dart:async';

import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/core/extensions/list_ext.dart';
import 'package:style_me/core/network/utils/image_process/image_fetcher.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/checkroom/domain/get_updated_selected_clothes_use_case.dart';
import 'package:style_me/features/checkroom/domain/get_user_original_photos_use_case.dart';
import 'package:style_me/features/checkroom/presentation/state/checkroom_state_holder.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_position_enum.dart';
import 'package:style_me/features/wardrobe/data/models/photo_item.dart';
import 'package:style_me/features/wardrobe/data/models/user_photos/user_photo.dart';
import 'package:style_me/features/wardrobe/domain/clothing/get_clothes_use_case.dart';
import 'package:style_me/features/wardrobe/presentation/ui_models/clothing_list_search_parameters.dart';

part 'checkroom_view_model.g.dart';

@riverpod
class CheckroomViewModel extends _$CheckroomViewModel {
  late final GetUserOriginalPhotosUseCase _getUserOriginalPhotosUseCase;
  late final GetUpdatedSelectedClothesUseCase _getUpdatedSelectedClothesUseCase;
  late final GetClothesUseCase _getClothesUseCase;
  late final ImageFetcher _multipleImageFetcher;

  CheckroomViewModel() {
    _getUserOriginalPhotosUseCase = getIt();
    _getUpdatedSelectedClothesUseCase = getIt();
    _getClothesUseCase = getIt();
    _multipleImageFetcher = getIt();
  }

  @override
  CheckroomStateHolder build() {
    Future.microtask(() {
      getUserPhotos();
      getClothes(ClothingListSearchParameters());
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

  void onClothingSelected(Clothing selectedClothing) {
    List<Clothing> updatedSelectedClothes = _getUpdatedSelectedClothesUseCase(
      state.selectedClothes,
      selectedClothing,
    );

    if (updatedSelectedClothes.length == 2 &&
        updatedSelectedClothes.first.position == ClothingPositionEnum.BOTTOM) {
      updatedSelectedClothes = updatedSelectedClothes.reversed.toList();
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

  void unselectClothingBy(String id) {
    final updatedSelectedClothes = List.of(state.selectedClothes)
      ..removeWhere((clothing) => clothing.id == id);
    _setClothesWithSelection(state.clothes, updatedSelectedClothes);
  }

  /// clothing list handling
  Timer? _spamTimer;
  bool _isInitialLoading = true;

  Future getClothes(ClothingListSearchParameters searchParameters) async {
    state = state.copyWith(isClothesLoading: true);
    _spamTimer?.cancel();
    _spamTimer =
        Timer(Duration(seconds: 1), () => _performGetClothes(searchParameters));
  }

  Future _performGetClothes(
      ClothingListSearchParameters searchParameters) async {
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
      isClothesEmpty:
          _isInitialLoading ? convertedClothes.isEmpty : state.isClothesEmpty,
    );
    _isInitialLoading = false;
    _setClothesWithSelection(convertedClothes, state.selectedClothes);
  }

  void onSearchParametersChanged(
      ClothingListSearchParameters searchParameters) {
    getClothes(searchParameters);
  }

  CheckroomViewModel.test(
    this._getClothesUseCase,
    this._getUserOriginalPhotosUseCase,
    this._getUpdatedSelectedClothesUseCase,
    this._multipleImageFetcher,
  );

  bool isClothesFullyChosen() {
    final clothesPositions =
        state.selectedClothes.map((clothing) => clothing.position).toList();
    return (clothesPositions.length == 1 &&
            clothesPositions.firstOrNull == ClothingPositionEnum.FULL_BODY) ||
        (clothesPositions.length == 2 &&
            clothesPositions.none(
                (position) => position == ClothingPositionEnum.FULL_BODY));
  }
}
