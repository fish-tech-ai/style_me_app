import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/extensions/global_ext.dart';
import 'package:style_me/core/extensions/widget_ext.dart';
import 'package:style_me/core/lang/app_localizations.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/navigation/app_page.dart';
import 'package:style_me/features/settings/presentation/components/settings_banner.dart';
import 'package:style_me/features/settings/presentation/components/settings_delete_account_dialog_content.dart';
import 'package:style_me/features/settings/presentation/components/settings_item.dart';
import 'package:style_me/features/settings/presentation/components/settings_language_bottom_sheet_content.dart';
import 'package:style_me/features/settings/presentation/components/settings_report_bottom_sheet.dart';
import 'package:style_me/features/settings/presentation/components/settings_theme_bottom_sheet_content.dart';
import 'package:style_me/features/settings/presentation/state/settings_state_holder.dart';
import 'package:style_me/features/settings/presentation/state/view_models/settings_view_model.dart';
import 'package:style_me/features/settings/presentation/ui_models/change_password_args.dart';
import 'package:style_me/features/settings/presentation/ui_models/setting.dart';
import 'package:style_me/features/settings/presentation/ui_models/setting_action.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SettingsStateHolder state = ref.watch(settingsViewModelProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              SettingsBanner(email: state.userEmail),
              Column(
                children: state.appSettings
                    .mapIndexed((index, setting) => SettingsItem(
                          setting: setting,
                          onItemClicked: (item) =>
                              handleAction(ref, setting, index),
                        ))
                    .toList(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      localizations.accountSettings,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  ...state.accountSettings.mapIndexed((index, setting) =>
                      SettingsItem(
                        setting: setting,
                        onItemClicked: (item) =>
                            handleAction(ref, setting, index),
                      ).orEmpty(index == 0 && state.isUserFromGoogleSignIn)),
                ],
              )
            ],
          ).orLoading(state.isLoading),
        ),
      ),
    );
  }

  void handleAction(WidgetRef ref, Setting setting, int settingIndex) {
    final SettingsViewModel viewModel =
        ref.read(settingsViewModelProvider.notifier);
    if (setting.action != null) {
      switch (setting.action!) {
        case SettingAction.openThemeBottomSheet:
          showAppModalBottomSheet(
            context: ref.context,
            child: SettingsThemeBottomSheetContent(
              onItemSelected: (theme) =>
                  viewModel.changeTheme(theme, settingIndex),
            ),
          );
          break;
        case SettingAction.openLanguageBottomSheet:
          showAppModalBottomSheet(
            context: ref.context,
            child: SettingsLanguageBottomSheetContent(
              onItemSelected: (lang) =>
                  onLanguageSelected(lang, ref, settingIndex, viewModel),
            ),
          );
          break;
        case SettingAction.openReportBottomSheet:
          showAppModalBottomSheet(
            context: ref.context,
            child: SettingsReportBottomSheet(
                onSubmit: viewModel.submitIssueReport),
          );
          break;
        case SettingAction.openDeleteAccountDialog:
          showAppDialog(
            context: ref.context,
            borderColor: ref.context.colorScheme.error,
            child: SettingsDeleteAccountDialogContent(
              shouldNotExpectPassword:
                  ref.read(settingsViewModelProvider).isUserFromGoogleSignIn,
              onDeleteClicked: () => viewModel.deleteAccount(() {
                onUserLogout(ref);
              }),
            ),
          );
          break;
        case SettingAction.logOut:
          viewModel.logOut(() {
            onUserLogout(ref);
          });
          break;
        case SettingAction.goToChangePassword:
          ref.context.push(AppPage.changePasswordPage.path,
              extra: ChangePasswordPageArgs(null, false));
      }
    }
  }

  void onUserLogout(WidgetRef ref) {
    ref
        .read(appGlobalViewModelProvider.notifier)
        .selectBottomNavItem(AppPage.homePage);
    ref.context.go(AppPage.authPage.path);
  }

  void onLanguageSelected(
    Locale lang,
    WidgetRef ref,
    int settingIndex,
    SettingsViewModel viewModel,
  ) async {
    final currentLanguage = ref.read(appGlobalViewModelProvider).lang;
    if (lang.toLanguageTag() == currentLanguage?.toLanguageTag()) {
      return;
    }
    LocalizationHelper.init(await AppLocalizations.delegate.load(lang));
    viewModel.changeLanguage(lang, settingIndex);
  }
}
