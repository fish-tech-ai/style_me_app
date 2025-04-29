import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/network/failures/server_failure.dart';
import 'package:style_me/core/network/utils/image_process/image_fetcher.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/checkroom/domain/get_user_original_photos_use_case.dart';
import 'package:style_me/features/checkroom/presentation/state/checkroom_state_holder.dart';
import 'package:style_me/features/checkroom/presentation/state/checkroom_view_model.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_category_enum.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_position_enum.dart';
import 'package:style_me/features/wardrobe/data/models/user_photos/user_photo.dart';
import 'package:style_me/features/wardrobe/domain/clothing/get_clothes_use_case.dart';
import 'package:style_me/features/wardrobe/presentation/ui_models/clothing_list_search_parameters.dart';

import '../../../../helpers/shared_test_functions.dart';

class MockGetUserPhotosUseCase extends Mock implements GetUserOriginalPhotosUseCase {}

class MockGetClothesUseCase extends Mock implements GetClothesUseCase {}

class MockMultipleImageFetcher extends Mock implements ImageFetcher {}

void main() {
  late ProviderContainer container;
  late MockGetUserPhotosUseCase mockGetUserPhotosUseCase;
  late MockGetClothesUseCase mockGetClothesUseCase;
  late MockMultipleImageFetcher mockMultipleImageFetcher;
  late MockAppGlobalViewModel mockGlobal;

  setUp(() {
    mockGetTemporaryDirectory();
    mockGetUserPhotosUseCase = MockGetUserPhotosUseCase();
    mockGetClothesUseCase = MockGetClothesUseCase();
    mockMultipleImageFetcher = MockMultipleImageFetcher();
    mockGlobal = MockAppGlobalViewModel();
    container = ProviderContainer(
      overrides: [
        checkroomViewModelProvider.overrideWith(
          () => CheckroomViewModel.test(
            mockGetClothesUseCase,
            mockGetUserPhotosUseCase,
            mockMultipleImageFetcher,
          ),
        ),
        appGlobalViewModelProvider.overrideWith(() => mockGlobal)
      ],
    );
    registerFallbackValue(ClothingCategoryEnum.BLAZER);
    addTearDown(container.dispose);

    when(() => mockGetUserPhotosUseCase.call())
        .thenAnswer((_) async => Result.success([]));
    when(() => mockGetClothesUseCase.call(any(), any(), any()))
        .thenAnswer((_) async => Result.success([]));
    when(() => mockMultipleImageFetcher.downloadImagesToCachePaths([]))
        .thenAnswer((_) async => []);
  });

  test('initial state is loading and then updates with user photos on success',
      () async {
    final List<UserPhoto> userPhotosList = [];
    when(() => mockGetUserPhotosUseCase.call())
        .thenAnswer((_) async => Result.success(userPhotosList));

    container.read(checkroomViewModelProvider.notifier);

    await Future.delayed(Duration.zero);

    final CheckroomStateHolder state = container.read(checkroomViewModelProvider);

    await Future.delayed(Duration.zero);
    expect(state.isUserPhotosLoading, true);
    expect(state.userPhotos, []);
  });

  test('getClothes fetches and sets clothes with image paths', () async {
    final clothing1 = Clothing('1', 'name', "https://www.example.com",
        ClothingCategoryEnum.ALL, ClothingPositionEnum.BOTTOM);
    final clothing2 = Clothing('2', 'name', "https://www.example2.com",
        ClothingCategoryEnum.ALL, ClothingPositionEnum.BOTTOM);
    final clothingItems = [clothing1, clothing2];

    final states = <CheckroomStateHolder>[];
    final stateListener = container.listen<CheckroomStateHolder>(
      checkroomViewModelProvider,
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

    final notifier = container.read(checkroomViewModelProvider.notifier);

    await notifier.getClothes(ClothingListSearchParameters());

    await Future.delayed(Duration(milliseconds: 1100));

    final state = states.last;
    expect(state.isClothesLoading, false);
    expect(state.clothes.length, 2);
    expect(state.clothes.first.image, contains('path1'));
    verify(() => mockGetClothesUseCase.call('', null, ClothingCategoryEnum.ALL))
        .called(1);

    /// gonna be called once on initial and second later
    verify(() => mockMultipleImageFetcher.downloadImagesToCachePaths(any()))
        .called(2);
    stateListener.close();
  });

  test('getClothes handles failure result and sets loading to false', () async {
    final states = <CheckroomStateHolder>[];
    final stateListener = container.listen<CheckroomStateHolder>(
      checkroomViewModelProvider,
      (prev, next) => states.add(next),
      fireImmediately: true,
    );

    final fakeFailure = ServerFailure('Network error', 404);

    when(() => mockGetClothesUseCase.call(any(), any(), any()))
        .thenAnswer((_) async => Result.fail(fakeFailure));

    when(() => mockMultipleImageFetcher.downloadImagesToCachePaths(any()))
        .thenAnswer((_) async => []);

    final notifier = container.read(checkroomViewModelProvider.notifier);
    await notifier.getClothes(ClothingListSearchParameters());

    await Future.delayed(Duration(milliseconds: 1100));

    final finalState = states.last;

    expect(finalState.isClothesLoading, false);
    expect(finalState.clothes, isEmpty);
    verify(() => mockGetClothesUseCase.call('', null, ClothingCategoryEnum.ALL))
        .called(1);

    /// gonna be called once on initial
    verify(() => mockMultipleImageFetcher.downloadImagesToCachePaths(any()))
        .called(1);

    stateListener.close();
  });
}
