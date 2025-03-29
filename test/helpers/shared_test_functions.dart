import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:style_me/core/app/presentation/app_global_state_holder.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/lang/localizations_helper.dart';

import 'mock_app_localizations.dart';

class MockAppGlobalViewModel extends AutoDisposeNotifier<AppGlobalStateHolder> with Mock implements AppGlobalViewModel {
  @override
  AppGlobalStateHolder build() {
    return AppGlobalStateHolder(
      currentTheme: Brightness.light,
      lang: Locale('en'),
    );
  }
}

MockAppLocalizations initializeAndGetLocalizations() {
  final localizations = MockAppLocalizations();
  LocalizationHelper.init(localizations);
  return localizations;
}