import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style_me/core/app/domain/usecases/get_user_use_case.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/local/database.dart';
import 'package:style_me/core/network/failures/server_failure.dart';
import 'package:style_me/core/network/utils/image_process/image_fetcher.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/home/data/models/outfit.dart';
import 'package:style_me/features/home/data/models/recent_and_favorite_outfit_response.dart';
import 'package:style_me/features/home/domain/get_recent_and_favorite_outfit_use_case.dart';
import 'package:style_me/features/home/domain/set_is_outfit_favorite_use_case.dart';
import 'package:style_me/features/home/presentation/state/home_state_holder.dart';
import 'package:style_me/features/home/presentation/state/home_view_model.dart';

import '../../../helpers/shared_test_functions.dart';

class MockGetRecentAndFavoriteOutfitUseCase extends Mock
    implements GetRecentAndFavoriteOutfitUseCase {}

class MockSetIsOutfitFavoriteUseCase extends Mock
    implements SetIsOutfitFavoriteUseCase {}

class MockGetUserUseCase extends Mock implements GetUserUseCase {}

class MockImageFetcher extends Mock implements ImageFetcher {}

void main() {
  late ProviderContainer container;
  late MockGetRecentAndFavoriteOutfitUseCase mockGetOutfits;
  late MockSetIsOutfitFavoriteUseCase mockSetFavorite;
  late MockGetUserUseCase mockGetUser;
  late MockImageFetcher mockImageFetcher;
  late MockAppGlobalViewModel mockAppGlobal;

  setUp(() {
    mockGetOutfits = MockGetRecentAndFavoriteOutfitUseCase();
    mockSetFavorite = MockSetIsOutfitFavoriteUseCase();
    mockGetUser = MockGetUserUseCase();
    mockImageFetcher = MockImageFetcher();
    mockAppGlobal = MockAppGlobalViewModel();

    container = ProviderContainer(overrides: [
      homeViewModelProvider.overrideWith(() => HomeViewModel.test(
            mockGetOutfits,
            mockGetUser,
            mockImageFetcher,
            mockSetFavorite,
          )),
      appGlobalViewModelProvider.overrideWith(() => mockAppGlobal),
    ]);
    addTearDown(container.dispose);
  });

  test('initial state is loading and then sets data', () async {
    final recent = [Outfit("", "", "", isFavorite: false)];
    final favorites = [Outfit("", "", "", isFavorite: true)];
    final user = UserData(
        id: 1,
        name: "John",
        email: "",
        token: "",
        refreshToken: "",
        isFromGoogleSignIn: false);

    when(() => mockGetOutfits()).thenAnswer((_) async =>
        Result.success(RecentAndFavoriteOutfitResponse(favorites, recent)));

    when(() => mockImageFetcher.downloadImagesToCachePaths(any()))
        .thenAnswer((invocation) async => invocation.positionalArguments[0]);

    when(() => mockGetUser()).thenAnswer((_) async => Result.success(user));

    final notifier = container.read(homeViewModelProvider.notifier);
    final state = await notifier.future;

    registerFallbackValue(ServerFailure("message", 400));

    expect(state.userName, 'John');
    expect(state.recentPhotos.length, 1);
    expect(state.favorites.length, 1);
  });

  test('collect failure from getOutfits shows failure in AppGlobalViewModel',
      () async {
    when(() => mockGetOutfits())
        .thenAnswer((_) async => Result.fail(ServerFailure("Failed", 500)));
    when(() => mockImageFetcher.downloadImagesToCachePaths(any()))
        .thenAnswer((_) async => []);
    when(() => mockGetUser()).thenAnswer((_) async => Result.success(UserData(
        id: 1,
        name: "",
        email: "",
        token: "",
        refreshToken: "",
        isFromGoogleSignIn: false)));

    await container.read(homeViewModelProvider.notifier).future;

    verify(() => mockAppGlobal.showFailure(any())).called(1);
  });

  test(
    'toggleFavoriteFor toggles local state and triggers debounced favorite update',
    () async {
      final outfit =
          Outfit('123', 'Test Outfit', 'https://url.com', isFavorite: false);
      final initialState =
          HomeStateHolder(recentPhotos: [outfit], favorites: []);

      container.read(homeViewModelProvider.notifier).state =
          AsyncValue.data(initialState);

      when(() => mockSetFavorite.call(outfit.id, true))
          .thenAnswer((_) async => Result.success(null));

      final states = <AsyncValue<HomeStateHolder>>[];
      final listener = container.listen<AsyncValue<HomeStateHolder>>(
        homeViewModelProvider,
        (prev, next) => states.add(next),
        fireImmediately: true,
      );

      final notifier = container.read(homeViewModelProvider.notifier);
      notifier.toggleFavoriteFor(outfit);

      await Future.delayed(const Duration(milliseconds: 300));

      final updatedState = states.last;
      final updatedFavorites = updatedState.value?.favorites;

      expect(updatedFavorites, isNotNull);
      expect(updatedFavorites!.length, 1);
      expect(updatedFavorites.first.id, outfit.id);
      expect(updatedFavorites.first.isFavorite, true);

      verify(() => mockSetFavorite(outfit.id, true)).called(1);
      listener.close();
    },
  );

  test('getUserName sets user name correctly', () async {
    when(() => mockGetUser.call()).thenAnswer((_) async => Result.success(
        UserData(
            id: 1,
            name: "Alice",
            email: "",
            token: "",
            refreshToken: "",
            isFromGoogleSignIn: false)));
    final notifier = container.read(homeViewModelProvider.notifier);
    final name = await notifier.getUserName();

    expect(name, 'Alice');
  });

  test('getUserName shows failure on error', () async {
    when(() => mockGetUser.call())
        .thenAnswer((_) async => Result.fail(ServerFailure("Whoops", 500)));

    final notifier = container.read(homeViewModelProvider.notifier);
    final name = await notifier.getUserName();

    expect(name, '');
    verify(() => mockAppGlobal.showFailure(any())).called(1);
  });
}
