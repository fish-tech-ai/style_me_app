import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:style_me/core/network/utils/image_process/image_fetcher.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_category_enum.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_position_enum.dart';
import 'package:style_me/features/wardrobe/data/models/user_photos/user_photo.dart';
import 'package:style_me/features/wardrobe/domain/clothing/get_clothes_use_case.dart';
import 'package:style_me/features/wardrobe/domain/user_photo/get_user_photos_use_case.dart';
import 'package:style_me/features/wardrobe/presentation/state/viewmodels/wardrobe_view_model.dart';

import '../../../../../helpers/shared_test_functions.dart';

class MockGetClothesUseCase extends Mock implements GetClothesUseCase {}

class MockGetUserPhotosUseCase extends Mock implements GetUserPhotosUseCase {}

class MockMultipleImageFetcher extends Mock implements ImageFetcher {}

void main() {
  mockGetTemporaryDirectory();

  late ProviderContainer container;
  late MockGetClothesUseCase mockGetClothesUseCase;
  late MockGetUserPhotosUseCase mockGetUserPhotosUseCase;
  late MockMultipleImageFetcher mockMultipleImageFetcher;

  setUp(() {
    mockGetClothesUseCase = MockGetClothesUseCase();
    mockGetUserPhotosUseCase = MockGetUserPhotosUseCase();
    mockMultipleImageFetcher = MockMultipleImageFetcher();
    container = ProviderContainer(
      overrides: [
        wardrobeViewModelProvider.overrideWith(
          () => WardrobeViewModel.test(
            mockGetClothesUseCase,
            mockMultipleImageFetcher,
            mockGetUserPhotosUseCase,
          ),
        ),
      ],
    );
    registerFallbackValue(ClothingCategoryEnum.BLAZER);

    addTearDown(container.dispose);
  });

  test('initial state is loading and then updates with clothes on success',
      () async {
    final List<Clothing> clothingList = [];
    final List<UserPhoto> userPhotosList = [];
    when(() => mockGetClothesUseCase.call(any(), any(), any()))
        .thenAnswer((_) async => Result.success(clothingList));
    when(() => mockGetUserPhotosUseCase.call())
        .thenAnswer((_) async => Result.success(userPhotosList));
    when(() =>
            mockMultipleImageFetcher.handleImagesLoadingAndCache(any(), any()))
        .thenAnswer((_) async => [
              Uint8List.fromList([1, 2, 3])
            ]);

    container.read(wardrobeViewModelProvider.notifier);

    final state = container.read(wardrobeViewModelProvider);
    expect(state.isClothesLoading, true);
    expect(state.clothes, clothingList);
  });

  test('onSearchTextChanged updates state and triggers fetch', () async {
    when(() => mockGetClothesUseCase.call(any(), any(), any()))
        .thenAnswer((_) async => Result.success([]));
    when(() => mockGetUserPhotosUseCase.call())
        .thenAnswer((_) async => Result.success([]));
    when(() =>
            mockMultipleImageFetcher.handleImagesLoadingAndCache(any(), any()))
        .thenAnswer((_) async => [
              Uint8List.fromList([1, 2, 3])
            ]);

    final notifier = container.read(wardrobeViewModelProvider.notifier);
    notifier.onSearchTextChanged("jacket");

    expect(container.read(wardrobeViewModelProvider).searchText, "jacket");

    await Future.delayed(Duration(milliseconds: 1100));
    verify(() => mockGetClothesUseCase.call("jacket", any(), any())).called(1);
  });

  test('onFilterChanged updates filters and triggers fetch', () async {
    when(() => mockGetClothesUseCase.call(any(), any(), any()))
        .thenAnswer((_) async => Result.success([]));
    when(() => mockGetUserPhotosUseCase.call())
        .thenAnswer((_) async => Result.success([]));
    when(() =>
            mockMultipleImageFetcher.handleImagesLoadingAndCache(any(), any()))
        .thenAnswer((_) async => [
              Uint8List.fromList([1, 2, 3])
            ]);

    final notifier = container.read(wardrobeViewModelProvider.notifier);
    notifier.onFilterChanged(
      ClothingPositionEnum.BOTTOM,
      ClothingCategoryEnum.TOP,
    );

    final state = container.read(wardrobeViewModelProvider);
    expect(state.filterPosition, ClothingPositionEnum.BOTTOM);
    expect(state.filterCategory, ClothingCategoryEnum.TOP);

    await Future.delayed(Duration(milliseconds: 1100));
    verify(() => mockGetClothesUseCase.call(
            any(), ClothingPositionEnum.BOTTOM, ClothingCategoryEnum.TOP))
        .called(1);
  });

  test('clearFilters resets filters to default values', () {
    when(() => mockGetUserPhotosUseCase.call())
        .thenAnswer((_) async => Result.success([]));
    final notifier = container.read(wardrobeViewModelProvider.notifier);
    when(() =>
            mockMultipleImageFetcher.handleImagesLoadingAndCache(any(), any()))
        .thenAnswer((_) async => [
              Uint8List.fromList([1, 2, 3])
            ]);

    notifier.clearFilters();
    final state = container.read(wardrobeViewModelProvider);

    expect(state.filterPosition, null);
    expect(state.filterCategory, ClothingCategoryEnum.ALL);
  });
}
