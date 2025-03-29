import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:style_me/core/app/domain/usecases/get_current_theme_use_case.dart';
import 'package:style_me/core/app/domain/usecases/get_language_use_case.dart';
import 'package:style_me/core/app/domain/usecases/get_user_use_case.dart';
import 'package:style_me/core/app/domain/usecases/logout_user_use_case.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/extensions/theme_ext.dart';
import 'package:style_me/core/local/database.dart';
import 'package:style_me/core/network/failures/server_failure.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/settings/data/models/report_category.dart';
import 'package:style_me/features/settings/domain/add_report_use_case.dart';
import 'package:style_me/features/settings/domain/delete_account_use_case.dart';
import 'package:style_me/features/settings/presentation/state/view_models/settings_view_model.dart';
import '../../../../../helpers/shared_test_functions.dart';
import 'settings_view_model_test.mocks.dart';

@GenerateMocks([
  GetUserUseCase,
  GetCurrentThemeUseCase,
  GetLanguageUseCase,
  LogoutUserUseCase,
  DeleteAccountUseCase,
  AddReportUseCase,
])
void main() {
  late MockGetUserUseCase mockGetUserUseCase;
  late MockGetCurrentThemeUseCase mockGetCurrentThemeUseCase;
  late MockGetLanguageUseCase mockGetCurrentLangUseCase;
  late MockLogoutUserUseCase mockLogoutUserUseCase;
  late MockDeleteAccountUseCase mockDeleteAccountUseCase;
  late MockAddReportUseCase mockAddReportUseCase;
  late MockAppGlobalViewModel mockAppGlobalViewModel;
  late ProviderContainer container;
  late UserData userData;

  setUp(() {
    initializeAndGetLocalizations();
    mockAppGlobalViewModel = MockAppGlobalViewModel();
    mockGetUserUseCase = MockGetUserUseCase();
    mockGetCurrentThemeUseCase = MockGetCurrentThemeUseCase();
    mockGetCurrentLangUseCase = MockGetLanguageUseCase();
    mockLogoutUserUseCase = MockLogoutUserUseCase();
    mockDeleteAccountUseCase = MockDeleteAccountUseCase();
    mockAddReportUseCase = MockAddReportUseCase();
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
    when(mockGetUserUseCase.call())
        .thenAnswer((_) => Future.value(Result.success(userData)));
    when(mockGetCurrentThemeUseCase.call()).thenReturn(Brightness.dark);
    when(mockGetCurrentLangUseCase.call()).thenReturn(Locale("en"));

    container = ProviderContainer(overrides: [
      settingsViewModelProvider.overrideWith(
        () => SettingsViewModel.test(
          mockGetUserUseCase,
          mockGetCurrentThemeUseCase,
          mockGetCurrentLangUseCase,
          mockLogoutUserUseCase,
          mockDeleteAccountUseCase,
          mockAddReportUseCase,
        ),
      ),
      appGlobalViewModelProvider.overrideWith(() => mockAppGlobalViewModel)
    ]);
  });

  tearDown(() {
    container.dispose();
  });

  test('initial state is correct', () {
    final settingsViewModel =
        container.read(settingsViewModelProvider.notifier);

    expect(settingsViewModel.state.isLoading, true);
    expect(settingsViewModel.state.userEmail, "");
    expect(settingsViewModel.state.isUserFromGoogleSignIn, false);
    expect(
        settingsViewModel.state.selectedCategory, ReportCategory.OTHER_ISSUES);
  });

  test('getUser success', () async {
    final settingsViewModel =
        container.read(settingsViewModelProvider.notifier);
    await settingsViewModel.getUser();

    expect(settingsViewModel.state.isLoading, false);
    expect(settingsViewModel.state.userEmail, "email");
    expect(settingsViewModel.state.isUserFromGoogleSignIn, false);
  });

  test('getUser failure', () async {
    final settingsViewModel =
        container.read(settingsViewModelProvider.notifier);
    await settingsViewModel.getUser();

    expect(settingsViewModel.state.isLoading, false);
  });

  test('changeTheme updates state correctly', () {
    final settingsViewModel =
        container.read(settingsViewModelProvider.notifier);

    settingsViewModel.changeTheme(Brightness.dark, 0);

    expect(settingsViewModel.state.appSettings[0].subLabel,
        Brightness.dark.getThemeText());
  });

  test('changeLanguage updates state and calls AppGlobalViewModel', () {
    final settingsViewModel =
        container.read(settingsViewModelProvider.notifier);
    when(mockAppGlobalViewModel.changeLanguage(Locale("en"))).thenReturn(null);

    settingsViewModel.changeLanguage(Locale('en'), 1);

    verify(mockAppGlobalViewModel.changeLanguage(Locale('en'))).called(1);
    expect(settingsViewModel.state.appSettings[1].subLabel, 'languageEnglish');
  });

  test('submitIssueReport success', () async {
    final settingsViewModel =
        container.read(settingsViewModelProvider.notifier);

    final message = "reportSuccessMessage";
    when(mockAddReportUseCase.call(any))
        .thenAnswer((_) async => Result.success(dynamic));
    when(mockAppGlobalViewModel.showSuccessInfo(message)).thenReturn(null);

    await settingsViewModel.submitIssueReport('Test report');

    verify(mockAddReportUseCase.call(any)).called(1);
    verify(mockAppGlobalViewModel.showSuccessInfo(message)).called(1);
  });

  test('submitIssueReport failure', () async {
    final settingsViewModel =
        container.read(settingsViewModelProvider.notifier);

    final failure = ServerFailure("", 404);
    when(mockAddReportUseCase.call(any))
        .thenAnswer((_) async => Result.fail(failure));
    when(mockAppGlobalViewModel.showFailure(failure)).thenReturn(null);

    await settingsViewModel.submitIssueReport('Test report');

    verify(mockAddReportUseCase.call(any)).called(1);
    verify(mockAppGlobalViewModel.showFailure(failure)).called(1);
  });

  test('selectIssueReportCategory updates state correctly', () {
    final settingsViewModel =
        container.read(settingsViewModelProvider.notifier);

    settingsViewModel.selectIssueReportCategory(ReportCategory.APP_SETTINGS);

    expect(
        settingsViewModel.state.selectedCategory, ReportCategory.APP_SETTINGS);
  });

  test('changeDeleteDialogPassText updates password text', () {
    final settingsViewModel =
        container.read(settingsViewModelProvider.notifier);

    settingsViewModel.changeDeleteDialogPassText('newPassword');

    expect(settingsViewModel.state.deleteDialogState.password, 'newPassword');
    expect(settingsViewModel.state.deleteDialogState.errorMessage, null);
  });

  test('toggleDeleteDialogPassVisibility toggles visibility', () {
    final settingsViewModel =
        container.read(settingsViewModelProvider.notifier);

    final initialVisibility =
        settingsViewModel.state.deleteDialogState.isPasswordVisible;
    settingsViewModel.toggleDeleteDialogPassVisibility();

    expect(settingsViewModel.state.deleteDialogState.isPasswordVisible,
        !initialVisibility);
  });

  test('logOut calls logoutUserUseCase and onSuccess', () async {
    final settingsViewModel =
        container.read(settingsViewModelProvider.notifier);

    when(mockLogoutUserUseCase.call()).thenAnswer((_) async => {});

    bool onSuccessCalled = false;
    await settingsViewModel.logOut(() {
      onSuccessCalled = true;
    });

    verify(mockLogoutUserUseCase.call()).called(1);
    expect(onSuccessCalled, true);
  });

  test('deleteAccount success', () async {
    final settingsViewModel =
        container.read(settingsViewModelProvider.notifier);

    when(mockDeleteAccountUseCase.call(any))
        .thenAnswer((_) async => Result.success(null));
    when(mockLogoutUserUseCase.call()).thenAnswer((_) async => {});

    bool onSuccessCalled = false;
    await settingsViewModel.deleteAccount(() {
      onSuccessCalled = true;
    });

    verify(mockDeleteAccountUseCase.call(any)).called(1);
    verify(mockLogoutUserUseCase.call()).called(1);
    expect(onSuccessCalled, true);
    expect(settingsViewModel.state.deleteDialogState.isLoading, false);
    expect(settingsViewModel.state.deleteDialogState.password, '');
  });

  test('deleteAccount failure', () async {
    final settingsViewModel =
        container.read(settingsViewModelProvider.notifier);

    final failure = ServerFailure("", 404);
    when(mockDeleteAccountUseCase.call(any))
        .thenAnswer((_) async => Result.fail(failure));
    when(mockAppGlobalViewModel.showFailure(failure)).thenReturn(null);

    await settingsViewModel.deleteAccount(() {});

    verify(mockDeleteAccountUseCase.call(any)).called(1);
    verify(mockAppGlobalViewModel.showFailure(failure)).called(1);
    expect(settingsViewModel.state.deleteDialogState.isLoading, false);
  });
}
