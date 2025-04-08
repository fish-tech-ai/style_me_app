import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/core/extensions/list_ext.dart';
import 'package:style_me/core/network/utils/image_process/image_fetcher.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/checkroom/presentation/state/checkroom_state_holder.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_category_enum.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_position_enum.dart';
import 'package:style_me/features/wardrobe/domain/clothing/get_clothes_use_case.dart';

part 'checkroom_view_model.g.dart';

@riverpod
class CheckroomViewModel extends _$CheckroomViewModel {
  late final GetClothesUseCase _getClothesUseCase;
  late final ImageFetcher _multipleImageFetcher;

  CheckroomViewModel() {
    _getClothesUseCase = getIt();
    _multipleImageFetcher = getIt();
  }

  Timer? _spamTimer;

  @override
  CheckroomStateHolder build() {
    Future.microtask(() => getClothes());
    return CheckroomStateHolder();
  }

  Future getClothes() async {
    state = state.copyWith(
      clothesListState: state.clothesListState.copyWith(isClothesLoading: true),
    );
    _spamTimer?.cancel();
    _spamTimer = Timer(Duration(seconds: 1), () => _performGetClothes());
  }

  Future _performGetClothes() async {
    final Result<List<Clothing>> result = await _getClothesUseCase(
      state.clothesListState.searchText,
      state.clothesListState.filterPosition,
      state.clothesListState.filterCategory,
    );
    result.collect(
          (clothes) {
        _convertClothingImagesAndShow(clothes);
      },
          (failure) {
        ref.read(appGlobalViewModelProvider.notifier).showFailure(failure);
        state = state.copyWith(
          clothesListState:
          state.clothesListState.copyWith(isClothesLoading: false),
        );
      },
    );
  }

  void _convertClothingImagesAndShow(List<Clothing> clothesWithUrls) async {
    final clothesWithPaths =
    await _multipleImageFetcher.downloadImagesToCachePaths(clothesWithUrls);

    state = state.copyWith(
      clothesListState: state.clothesListState.copyWith(
        clothes: clothesWithPaths.asClothingList(),
        isClothesLoading: false,
      ),
    );
  }

  void clearFilters() {
    state = state.copyWith(
      clothesListState: state.clothesListState.copyWith(
        filterPosition: null,
        filterCategory: ClothingCategoryEnum.ALL,
      ),
    );
    getClothes();
  }

  void onSearchTextChanged(String text) {
    state = state.copyWith(
      clothesListState: state.clothesListState.copyWith(searchText: text),
    );
    getClothes();
  }

  void onFilterChanged(ClothingPositionEnum? clothingPosition,
      ClothingCategoryEnum clothingCategory) {
    state = state.copyWith(
      clothesListState: state.clothesListState.copyWith(
        filterPosition: clothingPosition,
        filterCategory: clothingCategory,
      ),
    );
    getClothes();
  }
}
