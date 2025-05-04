import 'dart:io';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart' as mockito;
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:style_me/core/app/presentation/app_global_state_holder.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/lang/localizations_helper.dart';

import 'mock_app_localizations.dart';

class MockitoAppGlobalViewModel
    extends AutoDisposeNotifier<AppGlobalStateHolder>
    with mockito.Mock
    implements AppGlobalViewModel {
  @override
  AppGlobalStateHolder build() {
    return AppGlobalStateHolder(
      currentTheme: Brightness.light,
      lang: Locale('en'),
    );
  }
}

class MockAppGlobalViewModel extends AutoDisposeNotifier<AppGlobalStateHolder>
    with mocktail.Mock
    implements AppGlobalViewModel {}

MockAppLocalizations initializeAndGetLocalizations() {
  final localizations = MockAppLocalizations();
  LocalizationHelper.init(localizations);
  return localizations;
}

/// this function should be ALWAYS awaited
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
    throw StateError('mockGetTemporaryDirectory() may only be called within a test.');
  }
}
