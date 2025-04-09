import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/network/failures/server_failure.dart';
import 'package:style_me/core/network/utils/image_process/image_fetcher.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_category_enum.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_position_enum.dart';
import 'package:style_me/features/wardrobe/domain/clothing/get_clothes_use_case.dart';
import 'package:style_me/features/wardrobe/presentation/state/states/clothing/clothes_list_state.dart';
import 'package:style_me/features/wardrobe/presentation/state/viewmodels/clothing/clothes_list_view_model.dart';

import '../../../../../../helpers/shared_test_functions.dart';

class MockGetClothesUseCase extends Mock implements GetClothesUseCase {}

class MockMultipleImageFetcher extends Mock implements ImageFetcher {}

void main() {
  late ProviderContainer container;
  late MockGetClothesUseCase mockGetClothesUseCase;
  late MockMultipleImageFetcher mockMultipleImageFetcher;
  late MockAppGlobalViewModel mockGlobal;

  setUp(() {
    mockGetTemporaryDirectory();
    mockGetClothesUseCase = MockGetClothesUseCase();
    mockMultipleImageFetcher = MockMultipleImageFetcher();
    mockGlobal = MockAppGlobalViewModel();
    container = ProviderContainer(
      overrides: [
        clothesListViewModelProvider.overrideWith(
          () => ClothesListViewModel.test(
            mockGetClothesUseCase,
            mockMultipleImageFetcher,
          ),
        ),
        appGlobalViewModelProvider.overrideWith(() => mockGlobal)
      ],
    );
    registerFallbackValue(ClothingCategoryEnum.BLAZER);
    addTearDown(container.dispose);
  });

  test('onSearchTextChanged updates state and triggers fetch', () async {
    when(() => mockGetClothesUseCase.call(any(), any(), any()))
        .thenAnswer((_) async => Result.success([]));
    when(() => mockMultipleImageFetcher.downloadImagesToCachePaths([]))
        .thenAnswer((_) async => []);

    final notifier = container.read(clothesListViewModelProvider.notifier);
    notifier.onSearchTextChanged("jacket");

    expect(container.read(clothesListViewModelProvider).searchText, "jacket");

    await Future.delayed(Duration(milliseconds: 1100));
    verify(() => mockGetClothesUseCase.call("jacket", any(), any())).called(1);
  });

  test('onFilterChanged updates filters and triggers fetch', () async {
    when(() => mockGetClothesUseCase.call(any(), any(), any()))
        .thenAnswer((_) async => Result.success([]));
    when(() => mockMultipleImageFetcher.downloadImagesToCachePaths([]))
        .thenAnswer((_) async => []);

    final notifier = container.read(clothesListViewModelProvider.notifier);
    notifier.onFiltersChanged(
      ClothingPositionEnum.BOTTOM,
      ClothingCategoryEnum.TOP,
    );

    final state = container.read(clothesListViewModelProvider);
    expect(state.filterPosition, ClothingPositionEnum.BOTTOM);
    expect(state.filterCategory, ClothingCategoryEnum.TOP);
    await Future.delayed(Duration(milliseconds: 1100));
    verify(() => mockGetClothesUseCase.call(
            any(), ClothingPositionEnum.BOTTOM, ClothingCategoryEnum.TOP))
        .called(1);
  });

  test('clearFilters resets filters to default values', () {
    when(() => mockGetClothesUseCase.call(any(), any(), any()))
        .thenAnswer((_) async => Result.success([]));
    when(() =>
        mockMultipleImageFetcher.downloadImagesToCachePaths([]))
        .thenAnswer((_) async => []);

    final notifier = container.read(clothesListViewModelProvider.notifier);
    notifier.clearFilters();
    final state = container.read(clothesListViewModelProvider);

    expect(state.filterPosition, null);
    expect(state.filterCategory, ClothingCategoryEnum.ALL);
  });

  test('onClothingModifyResult - update action updates the item', () {
    when(() => mockGetClothesUseCase.call(any(), any(), any()))
        .thenAnswer((_) async => Result.success([]));
    when(() => mockMultipleImageFetcher.downloadImagesToCachePaths([]))
        .thenAnswer((_) async => []);

    final notifier = container.read(clothesListViewModelProvider.notifier);

    final oldClothing = Clothing('1', 'name', "old_path",
        ClothingCategoryEnum.ALL, ClothingPositionEnum.BOTTOM);
    final updatedClothing = Clothing('1', 'name', "new_path",
        ClothingCategoryEnum.ALL, ClothingPositionEnum.BOTTOM);

    notifier.state = notifier.state.copyWith(clothes: [oldClothing]);
    final action = updatedClothing.withUpdateAction();
    notifier.onClothingModifyResult(action);

    final updatedState = container.read(clothesListViewModelProvider);
    expect(updatedState.clothes.length, 1);
    expect(updatedState.clothes.first.image, 'new_path');
  });

  test('onClothingModifyResult - delete action removes the item', () {
    when(() => mockGetClothesUseCase.call(any(), any(), any()))
        .thenAnswer((_) async => Result.success([]));
    when(() => mockMultipleImageFetcher.downloadImagesToCachePaths([]))
        .thenAnswer((_) async => []);

    final notifier = container.read(clothesListViewModelProvider.notifier);

    final clothing1 = Clothing('1', 'name', "path1", ClothingCategoryEnum.ALL,
        ClothingPositionEnum.BOTTOM);
    final clothing2 = Clothing('2', 'name', "path2", ClothingCategoryEnum.ALL,
        ClothingPositionEnum.BOTTOM);

    notifier.state = notifier.state.copyWith(clothes: [clothing1, clothing2]);

    final action = clothing1.withDeleteAction();

    notifier.onClothingModifyResult(action);

    final updatedState = container.read(clothesListViewModelProvider);
    expect(updatedState.clothes.length, 1);
    expect(updatedState.clothes.first.id, '2');
  });

  test('getClothes fetches and sets clothes with image paths', () async {
    final clothing1 = Clothing('1', 'name', "https://www.example.com",
        ClothingCategoryEnum.ALL, ClothingPositionEnum.BOTTOM);
    final clothing2 = Clothing('2', 'name', "https://www.example2.com",
        ClothingCategoryEnum.ALL, ClothingPositionEnum.BOTTOM);
    final clothingItems = [clothing1, clothing2];

    final states = <ClothesListState>[];
    final stateListener = container.listen<ClothesListState>(
      clothesListViewModelProvider,
      (prev, next) => states.add(next),
      fireImmediately: true,
    );

    when(() => mockGetClothesUseCase.call(any(), any(), any()))
        .thenAnswer((_) async => Result.success(clothingItems));

    when(() =>
            mockMultipleImageFetcher.downloadImagesToCachePaths(clothingItems))
        .thenAnswer((_) async => [
              clothing1.copyWith(image: "path1"),
              clothing2.copyWith(image: "path2")
            ]);

    final notifier = container.read(clothesListViewModelProvider.notifier);

    await notifier.getClothes();

    await Future.delayed(Duration(milliseconds: 1100));

    final state = states.last;
    expect(state.isClothesLoading, false);
    expect(state.clothes.length, 2);
    expect(state.clothes.first.image, contains('path1'));
    verify(() => mockGetClothesUseCase.call('', null, ClothingCategoryEnum.ALL))
        .called(1);
    verify(() => mockMultipleImageFetcher.downloadImagesToCachePaths(any()))
        .called(1);
    stateListener.close();
  });

  test('getClothes handles failure result and sets loading to false', () async {
    final states = <ClothesListState>[];
    final stateListener = container.listen<ClothesListState>(
      clothesListViewModelProvider,
          (prev, next) => states.add(next),
      fireImmediately: true,
    );

    final fakeFailure = ServerFailure('Network error', 404);

    when(() => mockGetClothesUseCase.call(any(), any(), any()))
        .thenAnswer((_) async => Result.fail(fakeFailure));

    when(() => mockMultipleImageFetcher.downloadImagesToCachePaths(any()))
        .thenAnswer((_) async => []);

    final notifier = container.read(clothesListViewModelProvider.notifier);
    await notifier.getClothes();

    await Future.delayed(Duration(milliseconds: 1100));

    final finalState = states.last;

    expect(finalState.isClothesLoading, false);
    expect(finalState.clothes, isEmpty);
    verify(() => mockGetClothesUseCase.call('', null, ClothingCategoryEnum.ALL))
        .called(1);
    verifyNever(() => mockMultipleImageFetcher.downloadImagesToCachePaths(any()));

    stateListener.close();
  });
}
