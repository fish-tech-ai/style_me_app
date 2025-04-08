
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style_me/core/network/utils/image_process/image_fetcher.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_category_enum.dart';
import 'package:style_me/features/wardrobe/data/models/user_photos/user_photo.dart';
import 'package:style_me/features/wardrobe/domain/user_photo/get_user_photos_use_case.dart';
import 'package:style_me/features/wardrobe/presentation/state/states/wardrobe_state_holder.dart';
import 'package:style_me/features/wardrobe/presentation/state/viewmodels/wardrobe_view_model.dart';

import '../../../../../helpers/shared_test_functions.dart';

class MockGetUserPhotosUseCase extends Mock implements GetUserPhotosUseCase {}

class MockMultipleImageFetcher extends Mock implements ImageFetcher {}

void main() {
  late ProviderContainer container;
  late MockGetUserPhotosUseCase mockGetUserPhotosUseCase;
  late MockMultipleImageFetcher mockMultipleImageFetcher;

  setUp(() {
    mockGetTemporaryDirectory();
    mockGetUserPhotosUseCase = MockGetUserPhotosUseCase();
    mockMultipleImageFetcher = MockMultipleImageFetcher();
    container = ProviderContainer(
      overrides: [
        wardrobeViewModelProvider.overrideWith(
          () => WardrobeViewModel.test(
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
    final List<UserPhoto> userPhotosList = [];
    when(() => mockGetUserPhotosUseCase.call())
        .thenAnswer((_) async => Result.success(userPhotosList));
    when(() =>
            mockMultipleImageFetcher.downloadImagesToCachePaths(userPhotosList))
        .thenAnswer((_) async => userPhotosList);

    container.read(wardrobeViewModelProvider.notifier);

    await Future.delayed(Duration.zero);

    final WardrobeStateHolder state = container.read(wardrobeViewModelProvider);

    await Future.delayed(Duration.zero);
    expect(state.isUserPhotosLoading, true);
    expect(state.userPhotos, userPhotosList);
  });
}
