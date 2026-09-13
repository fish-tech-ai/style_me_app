
import 'package:flutter_test/flutter_test.dart';
import 'package:gal/gal.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style_me/core/network/failures/gal_failure.dart';
import 'package:style_me/core/network/failures/permission_failure.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/home/data/models/outfit.dart';
import 'package:style_me/features/home/data/models/outfit_original_photo_response.dart';
import 'package:style_me/features/home/domain/download_to_gallery_with_permissions_use_case.dart';
import 'package:style_me/features/home/domain/get_original_outfit_photo_use_case.dart';
import 'package:style_me/features/home/domain/set_is_outfit_favorite_use_case.dart';
import 'package:style_me/features/home/presentation/state/details/outfit_details_view_model.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/network/utils/image_process/image_fetcher.dart';

import '../../../helpers/shared_test_functions.dart';

class MockGetOriginalPhotoUseCase extends Mock
    implements GetOriginalOutfitPhotoUseCase {}

class MockImageFetcher extends Mock implements ImageFetcher {}

class MockSetIsOutfitFavoriteUseCase extends Mock
    implements SetIsOutfitFavoriteUseCase {}

class MockDownloadToGalleryUseCase extends Mock
    implements DownloadToGalleryWithPermissionsUseCase {}

void main() {
  late ProviderContainer container;
  late MockGetOriginalPhotoUseCase mockGetOriginal;
  late MockImageFetcher mockImageFetcher;
  late MockSetIsOutfitFavoriteUseCase mockSetFavorite;
  late MockDownloadToGalleryUseCase mockDownload;
  late MockAppGlobalViewModel mockGlobal;

  final outfit = Outfit('1', 'Test Outfit', 'url', isFavorite: false);
  final originalUrl = 'https://original.com/image.webp';

  setUp(() {
    mockGetOriginal = MockGetOriginalPhotoUseCase();
    mockImageFetcher = MockImageFetcher();
    mockSetFavorite = MockSetIsOutfitFavoriteUseCase();
    mockDownload = MockDownloadToGalleryUseCase();
    mockGlobal = MockAppGlobalViewModel();

    container = ProviderContainer(overrides: [
      outfitDetailsViewModelProvider(outfit).overrideWith(() =>
          OutfitDetailsViewModel.test(mockGetOriginal, mockImageFetcher,
              mockSetFavorite, mockDownload)),
      appGlobalViewModelProvider.overrideWith(() => mockGlobal),
    ]);
    mockGetTemporaryDirectory();
    initializeAndGetLocalizations();

    final response = OutfitOriginalPhotoResponse(originalUrl);
    when(() => mockGetOriginal.call(outfit.id))
        .thenAnswer((_) async => Result.success(response));
    when(() => mockImageFetcher.downloadAndCacheImage(originalUrl, any()))
        .thenAnswer((_) async => {});
  });

  test('build() loads outfit with original photo', () async {
    final notifier =
        container.read(outfitDetailsViewModelProvider(outfit).notifier);
    final state = await notifier.future;

    expect(state.outfit.image, contains('${outfit.id}_original.webp'));
  });

  test('toggleIsFavorite updates state and triggers use case', () async {
    final listener = container.listen(
        outfitDetailsViewModelProvider(outfit), (_, __) {});

    final notifier =
        container.read(outfitDetailsViewModelProvider(outfit).notifier);
    await notifier.future;

    when(() => mockSetFavorite(outfit.id, true))
        .thenAnswer((_) async => Result.success(null));

    notifier.toggleIsFavorite();
    await Future.delayed(Duration(seconds: 2));

    final state = container.read(outfitDetailsViewModelProvider(outfit));
    expect(state.value!.isFavorite, true);

    verify(() => mockSetFavorite(outfit.id, true)).called(1);
    listener.close();
  });

  test('downloadOutfit sets loading and shows success', () async {
    final notifier =
        container.read(outfitDetailsViewModelProvider(outfit).notifier);
    await notifier.future;

    when(() => mockDownload(outfit.id, outfit.name))
        .thenAnswer((_) async => Result.success(null));

    await notifier.downloadOutfit();

    final state = container.read(outfitDetailsViewModelProvider(outfit));
    expect(state.value!.isDownloading, false);
    verify(() => mockGlobal.showSuccessInfo(any())).called(1);
  });

  test('downloadOutfit handles PermissionFailure', () async {
    final listener = container.listen(
        outfitDetailsViewModelProvider(outfit), (_, __) {});

    final notifier =
        container.read(outfitDetailsViewModelProvider(outfit).notifier);
    await notifier.future;

    when(() => mockDownload(outfit.id, outfit.name))
        .thenAnswer((_) async => Result.fail(PermissionFailure("")));

    await notifier.downloadOutfit();

    expect(
        container
            .read(outfitDetailsViewModelProvider(outfit))
            .value!
            .isNoPermissionSnackBarVisible,
        true);



    await Future.delayed(Duration(seconds: 6));
    expect(
        container
            .read(outfitDetailsViewModelProvider(outfit))
            .value!
            .isNoPermissionSnackBarVisible,
        false);
    listener.close();
  });

  test('downloadOutfit handles GalFailure', () async {
    final galFailure = GalFailure(GalExceptionType.accessDenied, "");
    final notifier =
        container.read(outfitDetailsViewModelProvider(outfit).notifier);
    await notifier.future;

    when(() => mockDownload(outfit.id, outfit.name))
        .thenAnswer((_) async => Result.fail(galFailure));

    await notifier.downloadOutfit();

    verify(() => mockGlobal.showErrorMessage(galFailure.getTranslatedText()))
        .called(1);
  });

  test('showNoPermissionsSnackBar toggles flag for 5 seconds', () async {
    final listener = container.listen(
        outfitDetailsViewModelProvider(outfit), (_, __) {});

    final notifier =
        container.read(outfitDetailsViewModelProvider(outfit).notifier);
    await notifier.future;

    notifier.showNoPermissionsSnackBar();

    expect(
        container
            .read(outfitDetailsViewModelProvider(outfit))
            .value!
            .isNoPermissionSnackBarVisible,
        true);

    await Future.delayed(Duration(seconds: 6));
    expect(
        container
            .read(outfitDetailsViewModelProvider(outfit))
            .value!
            .isNoPermissionSnackBarVisible,
        false);
    listener.close();
  });
}
