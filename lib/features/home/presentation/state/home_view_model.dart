import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:style_me/core/app/domain/usecases/get_user_use_case.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/core/extensions/list_ext.dart';
import 'package:style_me/core/network/utils/image_process/image_fetcher.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/home/data/models/outfit.dart';
import 'package:style_me/features/home/data/models/recent_and_favorite_outfit_response.dart';
import 'package:style_me/features/home/domain/get_recent_and_favorite_outfit_use_case.dart';
import 'package:style_me/features/home/domain/set_is_outfit_favorite_use_case.dart';
import 'package:style_me/features/home/presentation/state/home_state_holder.dart';
import 'package:style_me/features/wardrobe/data/models/photo_item.dart';

part 'home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late final GetRecentAndFavoriteOutfitUseCase
      _getFavoriteAndRecentOutfitsUseCase;
  late final ImageFetcher _imageFetcher;
  late final GetUserUseCase _getUserUseCase;
  late final SetIsOutfitFavoriteUseCase _setIsOutfitFavoriteUseCase;

  HomeViewModel() {
    _getFavoriteAndRecentOutfitsUseCase = getIt();
    _setIsOutfitFavoriteUseCase = getIt();
    _getUserUseCase = getIt();
    _imageFetcher = getIt();
  }

  @override
  Future<HomeStateHolder> build() async {
    final response = await getInitialData();
    final userName = await getUserName();
    return HomeStateHolder(
      recentPhotos: response.recent,
      favorites: response.favorites,
      userName: userName,
    );
  }

  Future<RecentAndFavoriteOutfitResponse> getInitialData() async {
    final Result<RecentAndFavoriteOutfitResponse> result =
        await _getFavoriteAndRecentOutfitsUseCase();

    RecentAndFavoriteOutfitResponse finalResponse =
        RecentAndFavoriteOutfitResponse(
      state.value?.favorites ?? [],
      state.value?.recentPhotos ?? [],
    );
    result.collect((response) {
      finalResponse = response;
    }, (failure) {
      ref.read(appGlobalViewModelProvider.notifier).showFailure(failure);
    });

    final recentFuture = _convertToOutfitsWithCachedPaths(finalResponse.recent);
    final favoritesFuture =
        _convertToOutfitsWithCachedPaths(finalResponse.favorites);

    final results = await Future.wait([favoritesFuture, recentFuture]);

    final favorites = results[0];
    final recent = results[1];
    return RecentAndFavoriteOutfitResponse(favorites, recent);
  }

  Future<String> getUserName() async {
    final result = await _getUserUseCase();
    String userName = "";
    result.collect((user) {
      userName = user.name;
    }, (failure) {
      ref.read(appGlobalViewModelProvider.notifier).showFailure(failure);
    });
    return userName;
  }

  Future<List<Outfit>> _convertToOutfitsWithCachedPaths(
      List<Outfit> outfitsWithUrls) async {
    final List<PhotoItem> clothesWithPaths =
        await _imageFetcher.downloadImagesToCachePaths(outfitsWithUrls);

    final List<Outfit> convertedOutfits = clothesWithPaths.asOutfitList();
    return convertedOutfits;
  }

  Timer? _spamTimer;

  void toggleFavoriteFor(PhotoItem outfit) {
    List<Outfit> recentOutfits = List.of(state.value!.recentPhotos);

    final List<Outfit> updatedRecentOutfits =
        recentOutfits.getWithToggledFavorite(outfit);

    final List<Outfit> updatedFavorites = updatedRecentOutfits.where((item) {
      return item.isFavorite;
    }).toList();

    state = AsyncValue.data(state.value!.copyWith(
        recentPhotos: updatedRecentOutfits, favorites: updatedFavorites));

    Outfit updatedOutfit =
        (outfit as Outfit).copyWith(isFavorite: !outfit.isFavorite);
    _spamTimer?.cancel();
    _spamTimer = Timer(
        Duration(milliseconds: 200), () => _performToggleLikeOutfit(updatedOutfit));
  }

  void _performToggleLikeOutfit(Outfit outfit) async {
    final result =
        await _setIsOutfitFavoriteUseCase(outfit.id, outfit.isFavorite);

    result.collect((_) {
      ///Do nothing
    }, (failure) {
      ref.read(appGlobalViewModelProvider.notifier).showFailure(failure);
    });
  }

  @visibleForTesting
  HomeViewModel.test(this._getFavoriteAndRecentOutfitsUseCase);
}
