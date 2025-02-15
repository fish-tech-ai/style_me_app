import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:style_me/core/app/domain/usecases/get_user_use_case.dart';
import 'package:style_me/core/app/domain/usecases/save_current_theme_use_case.dart';
import 'package:style_me/core/app/domain/usecases/set_language_use_case.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/local/database.dart';
import 'package:style_me/core/navigation/app_page.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/settings/presentation/state/settings_state_holder.dart';
import 'package:style_me/features/settings/presentation/ui_models/app_settings.dart';
import 'package:style_me/features/settings/presentation/ui_models/setting.dart';

part 'settings_view_model.g.dart';

@riverpod
class SettingsViewModel extends _$SettingsViewModel {
  late final SaveCurrentThemeUseCase _saveCurrentThemeUseCase;
  late final SetLanguageUseCase _setLanguageUseCase;
  late final GetUserUseCase _getUserUseCase;

  SettingsViewModel() {
    _saveCurrentThemeUseCase = getIt();
    _setLanguageUseCase = getIt();
    _getUserUseCase = getIt();
  }

  @override
  SettingsStateHolder build() {
    final globalState = ref.read(appGlobalViewModelProvider);
    final appSettings =
        AppSettings(globalState.lang!, globalState.currentTheme!);

    return SettingsStateHolder(appSettings: [
      Setting(
        label: localizations.theme,
        subLabel: appSettings.getThemeText(),
        actionText: localizations.change,
        onItemClicked: (_) => openThemeBottomSheet(),
      ),
      Setting(
        label: localizations.language,
        subLabel: appSettings.getLanguageText(),
        actionText: localizations.change,
        onItemClicked: (_) => openLanguageBottomSheet(),
      ),
      Setting(
          label: localizations.privacyPolicy,
          actionText: localizations.seeMore,
          path: AppPage.privacyPolicy.path),
      Setting(
        label: localizations.termsAndConditions,
        actionText: localizations.seeMore,
        path: AppPage.termsAndConditions.path,
      ),
      Setting(
        label: localizations.reportBug,
        onItemClicked: (_) => openReportBugBottomSheet(),
      ),
      Setting(
        label: localizations.about,
        actionText: localizations.seeMore,
        onItemClicked: (_) => openAboutDialog(),
      ),
    ], accountSettings: [
      Setting(
        label: localizations.changePassword,
        path: AppPage.changePasswordPage.path,
      ),
      Setting(
        label: localizations.logOut,
        onItemClicked: logOut,
      ),
      Setting(
          label: localizations.logOut,
          onItemClicked: logOut,
          forceForegroundColor: (BuildContext context) =>
              context.colorScheme.error),
    ]);
  }

  void openThemeBottomSheet() {}

  void openLanguageBottomSheet() {}

  void openReportBugBottomSheet() {}

  openAboutDialog() {}

  void logOut(GoRouter? router) {}

  Future _getUser() async {
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
}
