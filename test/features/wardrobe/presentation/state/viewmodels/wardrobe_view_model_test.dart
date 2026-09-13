import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/network/failures/server_failure.dart';
import 'package:style_me/core/network/utils/image_process/image_fetcher.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_category_enum.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_position_enum.dart';
import 'package:style_me/features/wardrobe/data/models/photo_item.dart';
import 'package:style_me/features/wardrobe/data/models/user_photos/user_photo.dart';
import 'package:style_me/features/wardrobe/domain/clothing/get_clothes_use_case.dart';
import 'package:style_me/features/wardrobe/domain/user_photo/get_user_photos_use_case.dart';
import 'package:style_me/features/wardrobe/presentation/state/states/wardrobe_state_holder.dart';
import 'package:style_me/features/wardrobe/presentation/state/viewmodels/wardrobe_view_model.dart';
import 'package:style_me/features/wardrobe/presentation/ui_models/clothing_list_search_parameters.dart';

import '../../../../../helpers/shared_test_functions.dart';

class MockGetUserPhotosUseCase extends Mock implements GetUserPhotosUseCase {}

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
        wardrobeViewModelProvider.overrideWith(
          () => WardrobeViewModel.test(
            mockMultipleImageFetcher,
            mockGetUserPhotosUseCase,
            mockGetClothesUseCase,
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
    final userPhoto = UserPhoto('1', 'Test', 'url');
    when(() => mockGetUserPhotosUseCase.call())
        .thenAnswer((_) async => Result.success([userPhoto]));
    when(() => mockMultipleImageFetcher.downloadImagesToCachePaths(any()))
        .thenAnswer(
            (inv) async => inv.positionalArguments[0] as List<PhotoItem>);


    final subscription =
        container.listen(wardrobeViewModelProvider, (_, __) {});
    container.read(wardrobeViewModelProvider.notifier);

    await Future.delayed(Duration(milliseconds: 1100));

    final WardrobeStateHolder state = container.read(wardrobeViewModelProvider);

    expect(state.isUserPhotosLoading, false);
    expect(state.userPhotos, [userPhoto]);
    subscription.close();
  });

  test('onClothingModifyResult - update action updates the item', () async {

    final subscription =
        container.listen(wardrobeViewModelProvider, (_, __) {});
    final notifier = container.read(wardrobeViewModelProvider.notifier);

    final oldClothing = Clothing('1', 'name', "old_path",
        ClothingCategoryEnum.ALL, ClothingPositionEnum.BOTTOM);
    final updatedClothing = Clothing('1', 'name', "new_path",
        ClothingCategoryEnum.ALL, ClothingPositionEnum.BOTTOM);

    notifier.state = notifier.state.copyWith(clothes: [oldClothing]);
    final action = updatedClothing.withUpdateAction();
    notifier.onClothingModifyResult(action);

    final updatedState = container.read(wardrobeViewModelProvider);
    expect(updatedState.clothes.length, 1);
    expect(updatedState.clothes.first.image, 'new_path');



    await Future.delayed(Duration(milliseconds: 1100));
    subscription.close();
  });

  test('onClothingModifyResult - delete action removes the item', () async {

    final subscription =
        container.listen(wardrobeViewModelProvider, (_, __) {});
    final notifier = container.read(wardrobeViewModelProvider.notifier);

    final clothing1 = Clothing('1', 'name', "path1", ClothingCategoryEnum.ALL,
        ClothingPositionEnum.BOTTOM);
    final clothing2 = Clothing('2', 'name', "path2", ClothingCategoryEnum.ALL,
        ClothingPositionEnum.BOTTOM);

    notifier.state = notifier.state.copyWith(clothes: [clothing1, clothing2]);

    final action = clothing1.withDeleteAction();

    notifier.onClothingModifyResult(action);

    final updatedState = container.read(wardrobeViewModelProvider);
    expect(updatedState.clothes.length, 1);
    expect(updatedState.clothes.first.id, '2');



    await Future.delayed(Duration(milliseconds: 1100));
    subscription.close();
  });

  test('getClothes fetches and sets clothes with image paths', () async {
    final clothing1 = Clothing('1', 'name', "https://www.example.com",
        ClothingCategoryEnum.ALL, ClothingPositionEnum.BOTTOM);
    final clothing2 = Clothing('2', 'name', "https://www.example2.com",
        ClothingCategoryEnum.ALL, ClothingPositionEnum.BOTTOM);
    final clothingItems = [clothing1, clothing2];

    final states = <WardrobeStateHolder>[];
    final stateListener = container.listen<WardrobeStateHolder>(
      wardrobeViewModelProvider,
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

    final notifier = container.read(wardrobeViewModelProvider.notifier);

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
    final states = <WardrobeStateHolder>[];
    final stateListener = container.listen<WardrobeStateHolder>(
      wardrobeViewModelProvider,
      (prev, next) => states.add(next),
      fireImmediately: true,
    );

    final fakeFailure = ServerFailure('Network error', 404);

    when(() => mockGetClothesUseCase.call(any(), any(), any()))
        .thenAnswer((_) async => Result.fail(fakeFailure));

    when(() => mockMultipleImageFetcher.downloadImagesToCachePaths(any()))
        .thenAnswer((_) async => []);

    final notifier = container.read(wardrobeViewModelProvider.notifier);
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
