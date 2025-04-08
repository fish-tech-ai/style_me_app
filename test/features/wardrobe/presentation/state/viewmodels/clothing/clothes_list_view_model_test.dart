
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:style_me/core/network/utils/image_process/image_fetcher.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_category_enum.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_position_enum.dart';
import 'package:style_me/features/wardrobe/domain/clothing/get_clothes_use_case.dart';
import 'package:style_me/features/wardrobe/presentation/state/viewmodels/clothing/clothes_list_view_model.dart';

import '../../../../../../helpers/shared_test_functions.dart';


class MockGetClothesUseCase extends Mock implements GetClothesUseCase {}

class MockMultipleImageFetcher extends Mock implements ImageFetcher {}

void main() {
  late ProviderContainer container;
  late MockGetClothesUseCase mockGetClothesUseCase;
  late MockMultipleImageFetcher mockMultipleImageFetcher;

  setUp(() {
    mockGetTemporaryDirectory();
    mockGetClothesUseCase = MockGetClothesUseCase();
    mockMultipleImageFetcher = MockMultipleImageFetcher();
    container = ProviderContainer(
      overrides: [
        clothesListViewModelProvider.overrideWith(
              () => ClothesListViewModel.test(
            mockGetClothesUseCase,
            mockMultipleImageFetcher,
          ),
        ),
      ],
    );
    registerFallbackValue(ClothingCategoryEnum.BLAZER);

    addTearDown(container.dispose);
  });

  test('onSearchTextChanged updates state and triggers fetch', () async {
    when(() => mockGetClothesUseCase.call(any(), any(), any()))
        .thenAnswer((_) async => Result.success([]));
    when(() =>
        mockMultipleImageFetcher.downloadImagesToCachePaths([]))
        .thenAnswer((_) async => []);

    final notifier = container.read(clothesListViewModelProvider.notifier);
    notifier.onSearchTextChanged("jacket");

    expect(
        container.read(clothesListViewModelProvider).searchText,
        "jacket");

    await Future.delayed(Duration(milliseconds: 1100));
    verify(() => mockGetClothesUseCase.call("jacket", any(), any())).called(1);
  });

  test('onFilterChanged updates filters and triggers fetch', () async {
    when(() => mockGetClothesUseCase.call(any(), any(), any()))
        .thenAnswer((_) async => Result.success([]));
    when(() =>
        mockMultipleImageFetcher.downloadImagesToCachePaths([]))
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
    final notifier = container.read(clothesListViewModelProvider.notifier);
    when(() =>
        mockMultipleImageFetcher.downloadImagesToCachePaths([]))
        .thenAnswer((_) async => []);

    notifier.clearFilters();
    final state = container.read(clothesListViewModelProvider);

    expect(state.filterPosition, null);
    expect(state.filterCategory, ClothingCategoryEnum.ALL);
  });
}