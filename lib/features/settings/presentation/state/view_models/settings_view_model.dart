import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:style_me/core/app/domain/usecases/get_current_theme_use_case.dart';
import 'package:style_me/core/app/domain/usecases/get_language_use_case.dart';
import 'package:style_me/core/app/domain/usecases/get_user_use_case.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/core/extensions/theme_ext.dart';
import 'package:style_me/core/local/database.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/settings/presentation/state/settings_state_holder.dart';

part 'settings_view_model.g.dart';

@riverpod
class SettingsViewModel extends _$SettingsViewModel {
  late final GetUserUseCase _getUserUseCase;
  late final GetCurrentThemeUseCase _getCurrentThemeUseCase;
  late final GetLanguageUseCase _getCurrentLangUseCase;

  SettingsViewModel() {
    _getUserUseCase = getIt();
    _getCurrentThemeUseCase = getIt();
    _getCurrentLangUseCase = getIt();
  }

  @override
  SettingsStateHolder build() {
    Future.microtask(() async {
      getUser();
    });

    return SettingsStateHolder.getDefault(
      _getCurrentThemeUseCase(),
      _getCurrentLangUseCase(),
    );
  }

  void logOut() {}

  void deleteAccount() {}

  void changeTheme(Brightness? brightness, int settingIndex) {
    final AppGlobalViewModel globalProvider =
        ref.read(appGlobalViewModelProvider.notifier);
    globalProvider.changeTheme(brightness);
    state = state.copyWith(
        appSettings: state.appSettings.mapIndexed((index, item) {
      if (settingIndex == index) {
        return item.copyWith(subLabel: brightness.getThemeText());
      }
      return item;
    }).toList());
  }

  void changeLanguage(Locale language, int settingIndex) async {
    final AppGlobalViewModel globalProvider =
        ref.read(appGlobalViewModelProvider.notifier);
    globalProvider.changeLanguage(language);
    state = state.copyWith(
      appSettings: SettingsStateHolder.getInitialAppSettings(
              _getCurrentThemeUseCase(), language)
          .toList(),
      accountSettings: SettingsStateHolder.getInitialAccountSettings(),
    );
  }

  Future getUser() async {
    state = state.copyWith(isLoading: true);
    final Result<UserData> result = await _getUserUseCase();
    result.collect(
      (userData) {
        state = state.copyWith(isLoading: false, userEmail: userData.email);
      },
      (failure) {
        ref.read(appGlobalViewModelProvider.notifier).showFailure(failure);
        state = state.copyWith(isLoading: false);
      },
    );
  }

  void submitIssueReport(String reportText) {
    //TODO when backend ready
  }
}
