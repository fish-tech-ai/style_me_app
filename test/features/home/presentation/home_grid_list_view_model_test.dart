import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gal/gal.dart';
import 'package:mocktail/mocktail.dart';

import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/network/failures/gal_failure.dart';
import 'package:style_me/core/network/failures/permission_failure.dart';
import 'package:style_me/core/network/utils/image_process/image_fetcher.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/home/data/models/outfit.dart';
import 'package:style_me/features/home/data/models/outfits_response.dart';
import 'package:style_me/features/home/domain/download_to_gallery_with_permissions_use_case.dart';
import 'package:style_me/features/home/domain/get_favorite_outfits_use_case.dart';
import 'package:style_me/features/home/domain/get_recent_outfits_use_case.dart';
import 'package:style_me/features/home/domain/set_is_outfit_favorite_use_case.dart';
import 'package:style_me/features/home/presentation/state/home_grid_list/home_grid_list_state_holder.dart';
import 'package:style_me/features/home/presentation/state/home_grid_list/home_grid_list_view_model.dart';
import 'package:style_me/features/home/presentation/ui_models/home_grid_type.dart';

import '../../../helpers/shared_test_functions.dart';

class MockGetFavorites extends Mock implements GetFavoriteOutfitsUseCase {}

class MockGetRecent extends Mock implements GetRecentOutfitsUseCase {}

class MockSetFavorite extends Mock implements SetIsOutfitFavoriteUseCase {}

class MockDownloadUseCase extends Mock
    implements DownloadToGalleryWithPermissionsUseCase {}

class MockImageFetcher extends Mock implements ImageFetcher {}

void main() {
  late ProviderContainer container;
  late MockGetFavorites mockFavorites;
  late MockGetRecent mockRecent;
  late MockSetFavorite mockSetFavorite;
  late MockDownloadUseCase mockDownload;
  late MockImageFetcher mockImageFetcher;
  late MockAppGlobalViewModel mockGlobal;

  setUp(() {
    initializeAndGetLocalizations();
    mockFavorites = MockGetFavorites();
    mockRecent = MockGetRecent();
    mockSetFavorite = MockSetFavorite();
    mockDownload = MockDownloadUseCase();
    mockImageFetcher = MockImageFetcher();
    mockGlobal = MockAppGlobalViewModel();

    container = ProviderContainer(overrides: [
      homeGridListViewModelProvider(HomeGridType.recentOutfits)
          .overrideWith(() => HomeGridListViewModel.test(
                mockFavorites,
                mockRecent,
                mockSetFavorite,
                mockDownload,
                mockImageFetcher,
              )),
      appGlobalViewModelProvider.overrideWith(() => mockGlobal),
    ]);

    when(() => mockRecent())
        .thenAnswer((_) async => Result.success(OutfitsResponse([])));

    when(() => mockImageFetcher.downloadImagesToCachePaths(any()))
        .thenAnswer((inv) async => inv.positionalArguments[0]);
  });

  test('loads recent outfits on build', () async {
    final outfit = Outfit('1', 'O1', 'url');
    when(() => mockRecent())
        .thenAnswer((_) async => Result.success(OutfitsResponse([outfit])));
    when(() => mockImageFetcher.downloadImagesToCachePaths(any()))
        .thenAnswer((inv) async => inv.positionalArguments[0]);

    final notifier = container.read(
        homeGridListViewModelProvider(HomeGridType.recentOutfits).notifier);
    final result = await notifier.future;

    expect(result.outfits.length, 1);
    expect(result.outfits.first.id, '1');
  });

  test('downloadPhoto success shows success toast', () async {
    final outfit = Outfit('1', 'Name', 'url');

    when(() => mockDownload(outfit.id, outfit.name))
        .thenAnswer((_) async => Result.success(null));

    when(() => mockRecent())
        .thenAnswer((_) async => Result.success(OutfitsResponse([])));

    when(() => mockImageFetcher.downloadImagesToCachePaths(any()))
        .thenAnswer((inv) async => inv.positionalArguments[0]);

    final provider = homeGridListViewModelProvider(HomeGridType.recentOutfits);

    final listener = container.listen(provider, (_, __) {});
    final notifier = container.read(provider.notifier);
    await notifier.future;

    await notifier.downloadPhoto(outfit);

    verify(() => mockGlobal.showSuccessInfo(any())).called(1);


    await Future.delayed(Duration(seconds: 6));
    listener.close();
  });

  test('downloadPhoto with PermissionFailure shows permission snackbar',
      () async {
    final outfit = Outfit('1', 'Name', 'url');

    when(() => mockDownload(outfit.id, outfit.name))
        .thenAnswer((_) async => Result.fail(PermissionFailure("")));

    when(() => mockRecent())
        .thenAnswer((_) async => Result.success(OutfitsResponse([outfit])));

    final provider = homeGridListViewModelProvider(HomeGridType.recentOutfits);
    final listener = container.listen(provider, (_, __) {});
    final notifier = container.read(provider.notifier);
    await notifier.future;
    await notifier.downloadPhoto(outfit);

    final state = container
        .read(homeGridListViewModelProvider(HomeGridType.recentOutfits));
    expect(state.value?.isNoPermissionSnackBarVisible, true);



    await Future.delayed(Duration(seconds: 6));
    final updated = container
        .read(homeGridListViewModelProvider(HomeGridType.recentOutfits));
    expect(updated.value?.isNoPermissionSnackBarVisible, false);
    listener.close();
  });

  test('downloadPhoto with GalFailure shows translated message', () async {
    final outfit = Outfit('1', 'Name', 'url');
    final galFailure = GalFailure(GalExceptionType.accessDenied, "");

    when(() => mockDownload(outfit.id, outfit.name))
        .thenAnswer((_) async => Result.fail(galFailure));

    when(() => mockRecent())
        .thenAnswer((_) async => Result.success(OutfitsResponse([outfit])));

    final provider = homeGridListViewModelProvider(HomeGridType.recentOutfits);

    final listener = container.listen(provider, (_, __) {});
    final notifier = container.read(provider.notifier);
    await notifier.future;
    await notifier.downloadPhoto(outfit);

    verify(() => mockGlobal.showErrorMessage(galFailure.getTranslatedText()))
        .called(1);


    await Future.delayed(Duration(seconds: 6));
    listener.close();
  });

  test(
    'toggleFavoriteFor toggles local state and triggers debounced favorite update',
    () async {
      final outfit =
          Outfit('123', 'Test Outfit', 'https://url.com', isFavorite: false);
      final initialState = HomeGridListStateHolder(outfits: [outfit]);

      when(() => mockRecent())
          .thenAnswer((_) async => Result.success(OutfitsResponse([outfit])));

      when(() => mockSetFavorite.call(outfit.id, true))
          .thenAnswer((_) async => Result.success(null));

      final states = <AsyncValue<HomeGridListStateHolder>>[];
      final listener = container.listen<AsyncValue<HomeGridListStateHolder>>(
        homeGridListViewModelProvider(HomeGridType.recentOutfits),
        (prev, next) => states.add(next),
        fireImmediately: true,
      );

      final notifier = container.read(
          homeGridListViewModelProvider(HomeGridType.recentOutfits).notifier)
        ..state = AsyncValue.data(initialState);

      notifier.toggleFavoriteFor(outfit);

      final updatedState = states.last;
      final updatedOutfits = updatedState.value?.outfits;

      expect(updatedOutfits, isNotNull);
      expect(updatedOutfits!.length, 1);
      expect(updatedOutfits.first.id, outfit.id);
      expect(updatedOutfits.first.isFavorite, true);

      await Future.delayed(const Duration(milliseconds: 300));

      verify(() => mockSetFavorite(outfit.id, true)).called(1);
      listener.close();
    },
  );

  test('deletePhoto removes photo if type == favorites', () async {
    final outfit = Outfit('1', 'name', 'url', isFavorite: true);
    final provider = homeGridListViewModelProvider(HomeGridType.recentOutfits);
    final notifier = container.read(provider.notifier);
    await notifier.future;

    notifier.state = AsyncValue.data(HomeGridListStateHolder(outfits: []));

    when(() => mockSetFavorite(outfit.id, false))
        .thenAnswer((_) async => Result.success(null));

    notifier.deletePhoto(outfit);

    final state = container.read(provider);
    expect(state.value!.outfits, isEmpty);
  });

  test('showNoPermissionsSnackBar toggles state flags', () async {
    final listener = container.listen(
        homeGridListViewModelProvider(HomeGridType.recentOutfits), (_, __) {});
    final notifier = container.read(
        homeGridListViewModelProvider(HomeGridType.recentOutfits).notifier);
    await notifier.future;

    notifier.showNoPermissionsSnackBar();

    final initial = container
        .read(homeGridListViewModelProvider(HomeGridType.recentOutfits));

    expect(
      initial is AsyncData<HomeGridListStateHolder> &&
          initial.value.isNoPermissionSnackBarVisible,
      true,
    );

    await Future.delayed(Duration(seconds: 6));

    final updated = container
        .read(homeGridListViewModelProvider(HomeGridType.recentOutfits));

    expect(
      updated is AsyncData<HomeGridListStateHolder> &&
          updated.value.isNoPermissionSnackBarVisible,
      false,
    );
    listener.close();
  });

  test("showLoadingSnackBar toggles isDownloading", () async {
    final listener = container.listen(
        homeGridListViewModelProvider(HomeGridType.recentOutfits), (_, __) {});
    final notifier = container.read(
        homeGridListViewModelProvider(HomeGridType.recentOutfits).notifier);
    await notifier.future;
    notifier.showLoadingSnackBar();

    AsyncValue<HomeGridListStateHolder> getState() => container
        .read(homeGridListViewModelProvider(HomeGridType.recentOutfits));

    expect(
      getState().value?.isDownloading,
      true,
    );

    await Future.delayed(Duration(seconds: 6));

    expect(
      getState().value?.isDownloading,
      false,
    );
    listener.close();
  });
}
