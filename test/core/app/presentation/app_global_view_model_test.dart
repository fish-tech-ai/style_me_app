import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:style_me/core/app/domain/usecases/get_current_theme_use_case.dart';
import 'package:style_me/core/app/domain/usecases/get_language_use_case.dart';
import 'package:style_me/core/app/domain/usecases/save_current_theme_use_case.dart';
import 'package:style_me/core/app/domain/usecases/set_language_use_case.dart';
import 'package:style_me/core/app/presentation/app_global_state_holder.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/app/presentation/ui_models/banner_message.dart';
import 'package:style_me/core/app/presentation/ui_models/bottom_bar_state.dart';
import 'package:style_me/core/local/database.dart';
import 'package:style_me/core/network/connection.dart';
import 'package:style_me/core/network/failures/server_failure.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/core/utils/deep_link_manager.dart';
import 'package:style_me/features/auth/domain/confirm_email_use_case.dart';

import '../../../helpers/shared_test_functions.dart';
import 'app_global_view_model_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetCurrentThemeUseCase>(),
  MockSpec<SaveCurrentThemeUseCase>(),
  MockSpec<GetLanguageUseCase>(),
  MockSpec<SetLanguageUseCase>(),
  MockSpec<ConfirmEmailUseCase>(),
  MockSpec<DeepLinkManager>(),
  MockSpec<Connection>(),
])
void main() {
  late MockGetCurrentThemeUseCase mockGetCurrentThemeUseCase;
  late MockSaveCurrentThemeUseCase mockSaveCurrentThemeUseCase;
  late MockGetLanguageUseCase mockGetLanguageUseCase;
  late MockSetLanguageUseCase mockSetLanguageUseCase;
  late MockConfirmEmailUseCase mockConfirmEmailUseCase;
  late MockDeepLinkManager mockDeepLinkManager;
  late MockConnection mockConnection;
  late ProviderContainer container;
  late UserData userData;
  late AppGlobalViewModel appGlobalViewModel;

  setUp(() {
    initializeAndGetLocalizations();
    mockGetCurrentThemeUseCase = MockGetCurrentThemeUseCase();
    mockSaveCurrentThemeUseCase = MockSaveCurrentThemeUseCase();
    mockGetLanguageUseCase = MockGetLanguageUseCase();
    mockSetLanguageUseCase = MockSetLanguageUseCase();
    mockConfirmEmailUseCase = MockConfirmEmailUseCase();
    mockDeepLinkManager = MockDeepLinkManager();
    mockConnection = MockConnection();

    userData = UserData(
        id: 0,
        name: "name",
        email: "email",
        token: "token",
        refreshToken: "refreshToken",
        isFromGoogleSignIn: false);
    provideDummy(Result.success(userData));
    provideDummy(Result.fail(ServerFailure("", 1)));
    provideDummy(Result.success(dynamic));
    when(mockGetCurrentThemeUseCase.call()).thenReturn(Brightness.dark);
    when(mockGetLanguageUseCase.call()).thenReturn(Locale("en"));

    container = ProviderContainer(overrides: [
      appGlobalViewModelProvider.overrideWith(() => AppGlobalViewModel.test(
            mockGetCurrentThemeUseCase,
            mockSaveCurrentThemeUseCase,
            mockGetLanguageUseCase,
            mockSetLanguageUseCase,
            mockConfirmEmailUseCase,
            mockDeepLinkManager,
            mockConnection,
          ))
    ]);
    appGlobalViewModel = container.read(appGlobalViewModelProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  AppGlobalStateHolder getCurrentState() =>
      container.read(appGlobalViewModelProvider);

  test('initial state is correct', () {
    expect(
      getCurrentState(),
      AppGlobalStateHolder(
        currentTheme: Brightness.dark,
        lang: Locale("en"),
        isConnected: true,
        bannerMessage: BannerMessage(),
        bottomBarState: BottomBarState(),
      ),
    );
  });

  test('changeTheme updates state', () {
    const brightness = Brightness.dark;
    appGlobalViewModel.changeTheme(brightness);

    verify(mockSaveCurrentThemeUseCase(brightness)).called(1);
    expect(getCurrentState().currentTheme, equals(brightness));
  });

  test('changeLanguage updates state', () {
    final locale = Locale('en');
    appGlobalViewModel.changeLanguage(locale);

    verify(mockSetLanguageUseCase(locale)).called(1);
    expect(getCurrentState().lang, equals(locale));
  });

  test('showErrorMessage updates state and hides after delay', () async {
    appGlobalViewModel.showErrorMessage('Test error');

    expect(
      getCurrentState().bannerMessage,
      BannerMessage(message: 'Test error', isError: true, isVisible: true),
    );

    await Future.delayed(Duration(seconds: 6));

    expect(
      getCurrentState().bannerMessage.isVisible,
      false,
    );
  });

  test('showSuccessInfo updates state and hides after delay', () async {
    appGlobalViewModel.showSuccessInfo('Success');

    expect(
      getCurrentState().bannerMessage,
      BannerMessage(message: 'Success', isError: false, isVisible: true),
    );

    await Future.delayed(Duration(seconds: 6));

    expect(
      getCurrentState().bannerMessage.isVisible,
      false,
    );
  });

  test('initBottomNavItems initializes bottom bar items', () {
    appGlobalViewModel.initBottomNavItems();

    final bottomBarState = getCurrentState().bottomBarState;

    expect(bottomBarState.items.isNotEmpty, true);
  });

  test('setBottomNavBarVisibility updates visibility', () {
    appGlobalViewModel.setBottomNavBarVisibility(false);

    final isVisible =
        container.read(appGlobalViewModelProvider).bottomBarState.isVisible;

    expect(isVisible, false);
  });

  test('selectBottomNavItem updates selected index', () {
    appGlobalViewModel.initBottomNavItems();
    appGlobalViewModel.selectBottomNavItem(1);

    final selectedItem = container
        .read(appGlobalViewModelProvider)
        .bottomBarState
        .items
        .firstWhere((item) => item.isSelected);

    expect(selectedItem, isNotNull);
  });
}
