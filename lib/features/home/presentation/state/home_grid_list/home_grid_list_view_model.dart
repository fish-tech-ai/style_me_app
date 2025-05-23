import 'dart:async';

import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/core/extensions/list_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/network/failures/gal_failure.dart';
import 'package:style_me/core/network/failures/permission_failure.dart';
import 'package:style_me/core/network/utils/image_process/image_fetcher.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/home/data/models/outfit.dart';
import 'package:style_me/features/home/data/models/outfits_response.dart';
import 'package:style_me/features/home/domain/download_to_gallery_with_permissions_use_case.dart';
import 'package:style_me/features/home/domain/get_favorite_outfits_use_case.dart';
import 'package:style_me/features/home/domain/get_recent_outfits_use_case.dart';
import 'package:style_me/features/home/domain/set_is_outfit_favorite_use_case.dart';
import 'package:style_me/features/home/presentation/state/home_grid_list/home_grid_list_state_holder.dart';
import 'package:style_me/features/home/presentation/state/home_view_model.dart';
import 'package:style_me/features/home/presentation/ui_models/home_grid_type.dart';
import 'package:style_me/features/wardrobe/data/models/photo_item.dart';

part 'home_grid_list_view_model.g.dart';

@riverpod
class HomeGridListViewModel extends _$HomeGridListViewModel {
  late final GetFavoriteOutfitsUseCase _getFavoriteOutfitsUseCase;
  late final GetRecentOutfitsUseCase _getRecentOutfitsUseCase;
  late final SetIsOutfitFavoriteUseCase _setIsOutfitFavoriteUseCase;
  late final DownloadToGalleryWithPermissionsUseCase
      _downloadToGalleryWithPermissionsUseCase;
  late final ImageFetcher _imageFetcher;

  HomeGridListViewModel() {
    _getFavoriteOutfitsUseCase = getIt();
    _getRecentOutfitsUseCase = getIt();
    _setIsOutfitFavoriteUseCase = getIt();
    _downloadToGalleryWithPermissionsUseCase = getIt();
    _imageFetcher = getIt();
  }

  @override
  Future<HomeGridListStateHolder> build(HomeGridType type) async {
    return await initBasedOn(type);
  }

  Future<HomeGridListStateHolder> initBasedOn(HomeGridType type) async {
    final Result<OutfitsResponse> result;
    switch (type) {
      case HomeGridType.favorites:
        result = await _getFavoriteOutfitsUseCase();
      case HomeGridType.recentOutfits:
        result = await _getRecentOutfitsUseCase();
    }

    List<Outfit> outfits = [];
    result.collect((response) {
      outfits = response.data;
    }, (failure) {
      ref.read(appGlobalViewModelProvider.notifier).showFailure(failure);
    });
    final convertedOutfits =
        await _imageFetcher.downloadImagesToCachePaths(outfits);
    return HomeGridListStateHolder(outfits: convertedOutfits.asOutfitList());
  }

  void downloadPhoto(PhotoItem outfit) async {
    showLoadingSnackBar();
    final result = await _downloadToGalleryWithPermissionsUseCase(
        outfit.id, outfit.name);
    result.collect((_) {
      ref
          .read(appGlobalViewModelProvider.notifier)
          .showSuccessInfo(localizations.downloadImageSuccess);
    }, (failure) {
      final AppGlobalViewModel globalViewModel =
          ref.read(appGlobalViewModelProvider.notifier);
      if (failure is PermissionFailure) {
        showNoPermissionsSnackBar();
      } else if (failure is GalFailure) {
        globalViewModel.showErrorMessage(failure.getTranslatedText());
      } else {
        globalViewModel.showFailure(failure);
      }
    });
  }

  void showNoPermissionsSnackBar() async {
    state = AsyncData(
        state.requireValue.copyWith(isNoPermissionSnackBarVisible: true));
    await Future.delayed(Duration(seconds: 5));
    state = AsyncData(
        state.requireValue.copyWith(isNoPermissionSnackBarVisible: false));
  }

  void showLoadingSnackBar() async {
    state = AsyncData(state.requireValue.copyWith(isDownloading: true));
    await Future.delayed(Duration(seconds: 5));
    state = AsyncData(state.requireValue.copyWith(isDownloading: false));
  }

  void deletePhoto(PhotoItem outfit) {
    if (type != HomeGridType.favorites) {
      return;
    }

    toggleFavoriteFor(outfit, delayMilis: 1);
    final newOutfits =
        state.value!.outfits.whereNot((item) => item.id == outfit.id).toList();

    state = AsyncValue.data(state.value!.copyWith(outfits: newOutfits));
  }

  Timer? _spamTimer;

  void toggleFavoriteFor(PhotoItem outfit, {int delayMilis = 200}) {
    List<Outfit> recentOutfits = List.of(state.value!.outfits);
    final updatedOutfits = recentOutfits.getWithToggledFavorite(outfit);

    state = AsyncValue.data(state.value!.copyWith(outfits: updatedOutfits));

    Outfit updatedOutfit =
        (outfit as Outfit).copyWith(isFavorite: !outfit.isFavorite);
    _spamTimer?.cancel();
    _spamTimer = Timer(Duration(milliseconds: delayMilis),
        () => _performToggleLikeOutfit(updatedOutfit));
  }

  void _performToggleLikeOutfit(Outfit outfit) async {
    final result =
        await _setIsOutfitFavoriteUseCase(outfit.id, outfit.isFavorite);

    result.collect((_) {
      ref.invalidate(homeViewModelProvider);
    }, (failure) {
      ref.read(appGlobalViewModelProvider.notifier).showFailure(failure);
    });
  }

  HomeGridListViewModel.test(
    this._getFavoriteOutfitsUseCase,
    this._getRecentOutfitsUseCase,
    this._setIsOutfitFavoriteUseCase,
    this._downloadToGalleryWithPermissionsUseCase,
    this._imageFetcher,
  );
}
