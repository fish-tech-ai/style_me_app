import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart' as mockito;
import 'package:mocktail/mocktail.dart';
import 'package:style_me/core/app/domain/usecases/clear_app_cache_use_case.dart';
import 'package:style_me/core/app/domain/usecases/get_current_theme_use_case.dart';
import 'package:style_me/core/app/domain/usecases/get_language_use_case.dart';
import 'package:style_me/core/app/domain/usecases/get_user_use_case.dart';
import 'package:style_me/core/app/domain/usecases/load_app_legals_to_cache_use_case.dart';
import 'package:style_me/core/app/domain/usecases/save_current_theme_use_case.dart';
import 'package:style_me/core/app/domain/usecases/set_language_use_case.dart';
import 'package:style_me/core/app/presentation/app_global_state_holder.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/network/failures/failure.dart';
import 'package:style_me/core/network/connection.dart';
import 'package:style_me/core/utils/deep_link_manager.dart';
import 'package:style_me/features/auth/domain/confirm_email_use_case.dart';

import 'mock_app_localizations.dart';

class _MockGetCurrentTheme extends Mock implements GetCurrentThemeUseCase {}

class _MockSaveCurrentTheme extends Mock implements SaveCurrentThemeUseCase {}

class _MockGetLanguage extends Mock implements GetLanguageUseCase {}

class _MockGetUser extends Mock implements GetUserUseCase {}

class _MockSetLanguage extends Mock implements SetLanguageUseCase {}

class _MockConfirmEmail extends Mock implements ConfirmEmailUseCase {}

class _MockLoadAppLegals extends Mock implements LoadAppLegalsToCacheUseCase {}

class _MockClearAppCache extends Mock implements ClearAppCacheUseCase {}

class _MockDeepLinkManager extends Mock implements DeepLinkManager {}

class _MockConnection extends Mock implements Connection {}

class MockitoAppGlobalViewModel extends AppGlobalViewModel with mockito.Mock {
  MockitoAppGlobalViewModel()
      : super.test(
          _MockGetCurrentTheme(),
          _MockSaveCurrentTheme(),
          _MockGetLanguage(),
          _MockGetUser(),
          _MockSetLanguage(),
          _MockConfirmEmail(),
          _MockLoadAppLegals(),
          _MockClearAppCache(),
          _MockDeepLinkManager(),
          _MockConnection(),
        );

  @override
  AppGlobalStateHolder build() {
    return AppGlobalStateHolder(
      currentTheme: Brightness.light,
      lang: const Locale('en'),
    );
  }

  @override
  void showFailure(Failure failure) => super.noSuchMethod(
        Invocation.method(#showFailure, [failure]),
        returnValueForMissingStub: null,
      );

  @override
  void showErrorMessage(String message) => super.noSuchMethod(
        Invocation.method(#showErrorMessage, [message]),
        returnValueForMissingStub: null,
      );

  @override
  void showSuccessInfo(String message) => super.noSuchMethod(
        Invocation.method(#showSuccessInfo, [message]),
        returnValueForMissingStub: null,
      );

  @override
  void changeLanguage(Locale lang) => super.noSuchMethod(
        Invocation.method(#changeLanguage, [lang]),
        returnValueForMissingStub: null,
      );

  @override
  Future initUser() => (super.noSuchMethod(
        Invocation.method(#initUser, []),
        returnValue: Future<void>.value(),
        returnValueForMissingStub: Future<void>.value(),
      ) as Future);
}

class MockAppGlobalViewModel extends AppGlobalViewModel with Mock {
  MockAppGlobalViewModel()
      : super.test(
          _MockGetCurrentTheme(),
          _MockSaveCurrentTheme(),
          _MockGetLanguage(),
          _MockGetUser(),
          _MockSetLanguage(),
          _MockConfirmEmail(),
          _MockLoadAppLegals(),
          _MockClearAppCache(),
          _MockDeepLinkManager(),
          _MockConnection(),
        );

  @override
  AppGlobalStateHolder build() {
    return AppGlobalStateHolder(
      currentTheme: Brightness.light,
      lang: const Locale('en'),
    );
  }

  @override
  void showFailure(Failure failure) =>
      super.noSuchMethod(Invocation.method(#showFailure, [failure]));

  @override
  void showErrorMessage(String message) => super
      .noSuchMethod(Invocation.method(#showErrorMessage, [message]));

  @override
  void showSuccessInfo(String message) =>
      super.noSuchMethod(Invocation.method(#showSuccessInfo, [message]));

  @override
  void changeLanguage(Locale lang) =>
      super.noSuchMethod(Invocation.method(#changeLanguage, [lang]));

  @override
  Future initUser() =>
      super.noSuchMethod(Invocation.method(#initUser, [])) as Future;
}

MockAppLocalizations initializeAndGetLocalizations() {
  final localizations = MockAppLocalizations();
  LocalizationHelper.init(localizations);
  return localizations;
}

void mockGetTemporaryDirectory() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel =
      MethodChannel('plugins.flutter.io/path_provider');
  final dir = Directory("./mocked");
  dir.createSync();

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    if (methodCall.method == 'getTemporaryDirectory') {
      return dir.path;
    }
    return null;
  });

  try {
    addTearDown(() {
      if (dir.existsSync()) {
        dir.delete(recursive: true);
      }
    });
  } on StateError {
    throw StateError(
        'mockGetTemporaryDirectory() may only be called within a test.');
  }
}
