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
import 'package:style_me/features/wardrobe/data/models/io/original_image_response.dart';
import 'package:style_me/features/wardrobe/domain/clothing/delete_clothing_use_case.dart';
import 'package:style_me/features/wardrobe/domain/clothing/get_original_clothing_image_url_use_case.dart';
import 'package:style_me/features/wardrobe/domain/clothing/update_clothing_use_case.dart';
import 'package:style_me/features/wardrobe/presentation/state/viewmodels/clothing/edit_clothing_photo_view_model.dart';

import '../../../../../../helpers/shared_test_functions.dart';

class MockDeleteClothingPhotoUseCase extends Mock
    implements DeleteClothingUseCase {}

class MockUpdateClothingPhotoUseCase extends Mock
    implements UpdateClothingUseCase {}

class MockGetOriginalClothingImageUrlUseCase extends Mock
    implements GetOriginalClothingImageUrlUseCase {}

class MockImageFetcher extends Mock implements ImageFetcher {}

class FakeClothingPhoto extends Fake implements Clothing {}

void main() {
  late MockDeleteClothingPhotoUseCase mockDelete;
  late MockUpdateClothingPhotoUseCase mockUpdate;
  late MockGetOriginalClothingImageUrlUseCase mockGetUrl;
  late MockImageFetcher mockFetcher;
  late MockAppGlobalViewModel mockGlobal;
  late ProviderContainer container;

  final clothingPhoto = Clothing(
    "id123",
    "Profile",
    "url",
    ClothingCategoryEnum.OUTWEAR,
    ClothingPositionEnum.BOTTOM,
  );

  setUpAll(() {
    mockGetTemporaryDirectory();
    registerFallbackValue(ServerFailure("fail", 500));
    registerFallbackValue(ClothingCategoryEnum.ALL);
    registerFallbackValue(clothingPhoto);
  });

  setUp(() {
    mockDelete = MockDeleteClothingPhotoUseCase();
    mockUpdate = MockUpdateClothingPhotoUseCase();
    mockGetUrl = MockGetOriginalClothingImageUrlUseCase();
    mockFetcher = MockImageFetcher();
    mockGlobal = MockAppGlobalViewModel();

    container = ProviderContainer(overrides: [
      editClothingPhotoViewModelProvider
          .overrideWith(() => EditClothingPhotoViewModel.test(
                mockDelete,
                mockUpdate,
                mockGetUrl,
                mockFetcher,
              )),
      appGlobalViewModelProvider.overrideWith(() => mockGlobal),
    ]);

    addTearDown(container.dispose);
  });

  test('init loads image and sets state on success', () async {
    final signedUrl = "http://example.com/photo.webp";
    final response = OriginalImageUrlResponse(signedUrl);
    when(() => mockGetUrl.call(clothingPhoto.id))
        .thenAnswer((_) async => Result.success(response));
    when(() => mockFetcher.downloadAndCacheImage(any(), any()))
        .thenAnswer((_) async {});

    final notifier =
        container.read(editClothingPhotoViewModelProvider.notifier);
    await notifier.init(clothingPhoto);

    await untilCalled(
        () => mockFetcher.downloadAndCacheImage(any(), any()));

    final state = container.read(editClothingPhotoViewModelProvider);
    expect(state.isPageLoading, false);
    expect(
        state.originalImagePath, contains("${clothingPhoto.id}_original.webp"));
  });

  test('init calls showFailure on error', () async {
    when(() => mockGetUrl.call(clothingPhoto.id))
        .thenAnswer((_) async => Result.fail(ServerFailure("error", 500)));

    final notifier =
        container.read(editClothingPhotoViewModelProvider.notifier);
    await notifier.init(clothingPhoto);

    verify(() => mockGlobal.showFailure(any())).called(1);
    expect(container.read(editClothingPhotoViewModelProvider).isPageLoading,
        false);
  });

  test('deleteClothingPhoto success calls onSuccess', () async {
    when(() => mockDelete.call(clothingPhoto.id))
        .thenAnswer((_) async => Result.success(null));

    final notifier =
        container.read(editClothingPhotoViewModelProvider.notifier);
    notifier.state = notifier.state.copyWith(clothing: clothingPhoto);

    var called = false;
    await notifier.deleteClothing(() {
      called = true;
    });

    expect(called, true);
    expect(container.read(editClothingPhotoViewModelProvider).isDeleteLoading,
        false);
  });

  test('deleteClothingPhoto failure calls showFailure', () async {
    when(() => mockDelete.call(any()))
        .thenAnswer((_) async => Result.fail(ServerFailure("fail", 500)));

    final notifier =
        container.read(editClothingPhotoViewModelProvider.notifier);
    notifier.state = notifier.state.copyWith(clothing: clothingPhoto);

    await notifier.deleteClothing(() {});

    verify(() => mockGlobal.showFailure(any())).called(1);
    expect(container.read(editClothingPhotoViewModelProvider).isDeleteLoading,
        false);
  });

  test('updateClothingPhoto success calls onSuccess with updated ClothingPhoto',
      () async {
    when(() => mockUpdate.call(any(), any(), any()))
        .thenAnswer((_) async => Result.success(null));

    final notifier =
        container.read(editClothingPhotoViewModelProvider.notifier);
    notifier.state = notifier.state.copyWith(clothing: clothingPhoto);

    var called = false;
    await notifier.updateClothing((updated) {
      called = true;
      expect(updated.name, clothingPhoto.name);
    });

    expect(called, true);
    expect(container.read(editClothingPhotoViewModelProvider).isSaveLoading,
        false);
  });

  test('updateClothingPhoto failure calls showFailure', () async {
    when(() => mockUpdate.call(any(), any(), any()))
        .thenAnswer((_) async => Result.fail(ServerFailure("fail", 500)));

    final notifier =
        container.read(editClothingPhotoViewModelProvider.notifier);
    notifier.state = notifier.state.copyWith(clothing: clothingPhoto);

    await notifier.updateClothing((_) {});

    verify(() => mockGlobal.showFailure(any())).called(1);
    expect(container.read(editClothingPhotoViewModelProvider).isSaveLoading,
        false);
  });

  test('onNameTextChanged updates user photo name', () {
    final notifier =
        container.read(editClothingPhotoViewModelProvider.notifier);
    notifier.state = notifier.state.copyWith(clothing: clothingPhoto);

    notifier.onNameTextChanged("New Name");

    expect(
        container.read(editClothingPhotoViewModelProvider).clothing.name,
        "New Name");
  });

  test('onCategorySelected updates user photo category', () {
    final notifier =
        container.read(editClothingPhotoViewModelProvider.notifier);
    notifier.state = notifier.state.copyWith(clothing: clothingPhoto);

    notifier.onCategorySelected(ClothingCategoryEnum.ALL);

    expect(
        container
            .read(editClothingPhotoViewModelProvider)
            .clothing
            .category,
        ClothingCategoryEnum.ALL);
  });
}
