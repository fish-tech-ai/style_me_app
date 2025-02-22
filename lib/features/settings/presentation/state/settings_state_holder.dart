import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/extensions/locale_ext.dart';
import 'package:style_me/core/extensions/theme_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/navigation/app_page.dart';
import 'package:style_me/features/settings/presentation/state/delete_dialog_state.dart';
import 'package:style_me/features/settings/presentation/ui_models/setting.dart';
import 'package:style_me/features/settings/presentation/ui_models/setting_action.dart';

part 'settings_state_holder.freezed.dart';

@freezed
class SettingsStateHolder with _$SettingsStateHolder {
  const factory SettingsStateHolder({
    @Default([]) List<Setting> appSettings,
    @Default([]) List<Setting> accountSettings,
    @Default(true) bool isLoading,
    @Default("") String userEmail,
    @Default(DeleteDialogState()) DeleteDialogState deleteDialogState,
  }) = _SettingsStateHolder;

  factory SettingsStateHolder.getDefault(
      Brightness? currentTheme, Locale currentLang) {
    return SettingsStateHolder(
      appSettings:
          SettingsStateHolder.getInitialAppSettings(currentTheme, currentLang),
      accountSettings: SettingsStateHolder.getInitialAccountSettings(),
    );
  }

  static List<Setting> getInitialAppSettings(
      Brightness? currentTheme, Locale currentLang) {
    return [
      Setting(
        label: localizations.theme,
        subLabel: currentTheme.getThemeText(),
        actionText: localizations.change,
        action: SettingAction.openThemeBottomSheet,
      ),
      Setting(
        label: localizations.language,
        subLabel: currentLang.getLanguageText(),
        actionText: localizations.change,
        action: SettingAction.openLanguageBottomSheet,
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
        action: SettingAction.openReportBottomSheet,
      ),
      Setting(
        label: localizations.about,
        actionText: localizations.seeMore,
      ),
    ];
  }

  static List<Setting> getInitialAccountSettings() {
    return [
      Setting(
        label: localizations.changePassword,
        path: AppPage.changePasswordPage.path,
      ),
      Setting(
        label: localizations.logOut,
        action: SettingAction.logOut,
      ),
      Setting(
        label: localizations.deleteAccount,
        action: SettingAction.openDeleteAccountDialog,
        forceForegroundColor: (BuildContext context) =>
            context.colorScheme.error,
      ),
    ];
  }
}
