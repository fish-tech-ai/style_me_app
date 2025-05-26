import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/network/failures/failure.dart';
import 'package:style_me/core/network/failures/gal_failure.dart';
import 'package:style_me/core/network/failures/permission_failure.dart';
import 'package:style_me/core/network/utils/image_process/image_fetcher.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/home/data/models/outfit.dart';
import 'package:style_me/features/home/data/models/outfit_original_photo_response.dart';
import 'package:style_me/features/home/domain/download_to_gallery_with_permissions_use_case.dart';
import 'package:style_me/features/home/domain/get_original_outfit_photo_use_case.dart';
import 'package:style_me/features/home/domain/set_is_outfit_favorite_use_case.dart';
import 'package:style_me/features/home/presentation/state/details/outfit_details_state_holder.dart';
import 'package:style_me/features/home/presentation/state/home_view_model.dart';

part 'outfit_details_view_model.g.dart';

@riverpod
class OutfitDetailsViewModel extends _$OutfitDetailsViewModel {
  late final GetOriginalOutfitPhotoUseCase _getOriginalOutfitPhotoUseCase;
  late final ImageFetcher _imageFetcher;
  late final SetIsOutfitFavoriteUseCase _setIsOutfitFavoriteUseCase;
  late final DownloadToGalleryWithPermissionsUseCase
      _downloadToGalleryWithPermissionsUseCase;

  OutfitDetailsViewModel() {
    _getOriginalOutfitPhotoUseCase = getIt();
    _imageFetcher = getIt();
    _setIsOutfitFavoriteUseCase = getIt();
    _downloadToGalleryWithPermissionsUseCase = getIt();
  }

  @override
  Future<OutfitDetailsStateHolder> build(Outfit outfit) async {
    final updatedOutfit = await getOutfitWithOriginalPhoto(outfit);
    return OutfitDetailsStateHolder(
        outfit: updatedOutfit, isFavorite: outfit.isFavorite);
  }

  Future<Outfit> getOutfitWithOriginalPhoto(Outfit outfit) async {
    final Result<OutfitOriginalPhotoResponse> result =
        await _getOriginalOutfitPhotoUseCase(outfit.id);

    Outfit outfitWithOriginalPhoto = outfit;
    OutfitOriginalPhotoResponse? response;
    final cacheDir = await getTemporaryDirectory();
    result.collect((data) {
      response = data;
    }, (failure) {
      ref.read(appGlobalViewModelProvider.notifier).showFailure(failure);
    });

    if (response == null) {
      return outfit;
    }

    final String originalImagePath =
        '${cacheDir.path}/${outfit.id}_original.webp';
    await _imageFetcher.downloadAndCacheImage(
        response!.originalOutfitUrl, originalImagePath);
    outfitWithOriginalPhoto = outfit.copyWith(image: originalImagePath);

    return outfitWithOriginalPhoto;
  }

  Timer? _spamLikeTimer;

  void toggleIsFavorite() {
    if (state.value == null) {
      return;
    }
    state =
        AsyncData(state.value!.copyWith(isFavorite: !state.value!.isFavorite));
    _spamLikeTimer?.cancel();
    _spamLikeTimer =
        Timer(Duration(seconds: 1), () => _performToggleIsFavorite());
  }

  void _performToggleIsFavorite() async {
    final result = await _setIsOutfitFavoriteUseCase(
        state.value!.outfit.id, state.value!.isFavorite);

    result.collect((_) {
      ref.invalidate(homeViewModelProvider);
    }, (failure) {
      ref.read(appGlobalViewModelProvider.notifier).showFailure(failure);
    });
  }

  Future downloadOutfit() async {
    state = AsyncData(state.value!.copyWith(isDownloading: true));
    final result = await _downloadToGalleryWithPermissionsUseCase(
        state.requireValue.outfit.id, state.requireValue.outfit.name);
    result.collect((_) {
      ref
          .read(appGlobalViewModelProvider.notifier)
          .showSuccessInfo(localizations.downloadImageSuccess);
    }, (failure) {
      handleDownloadFailure(failure);
    });

    state = AsyncData(state.value!.copyWith(isDownloading: false));
  }

  void handleDownloadFailure(Failure failure) {
    final AppGlobalViewModel globalViewModel =
        ref.read(appGlobalViewModelProvider.notifier);
    if (failure is PermissionFailure) {
      showNoPermissionsSnackBar();
    } else if (failure is GalFailure) {
      globalViewModel.showErrorMessage(failure.getTranslatedText());
    } else {
      globalViewModel.showFailure(failure);
    }
  }

  void showNoPermissionsSnackBar() async {
    state = AsyncData(
        state.requireValue.copyWith(isNoPermissionSnackBarVisible: true));
    await Future.delayed(Duration(seconds: 5));
    state = AsyncData(
        state.requireValue.copyWith(isNoPermissionSnackBarVisible: false));
  }

  OutfitDetailsViewModel.test(
    this._getOriginalOutfitPhotoUseCase,
    this._imageFetcher,
    this._setIsOutfitFavoriteUseCase,
    this._downloadToGalleryWithPermissionsUseCase,
  );
}
