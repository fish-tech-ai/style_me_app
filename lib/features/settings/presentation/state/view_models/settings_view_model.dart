import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:style_me/core/app/domain/usecases/get_current_theme_use_case.dart';
import 'package:style_me/core/app/domain/usecases/get_language_use_case.dart';
import 'package:style_me/core/app/domain/usecases/get_user_use_case.dart';
import 'package:style_me/core/app/domain/usecases/logout_user_use_case.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/core/extensions/theme_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/local/database.dart';
import 'package:style_me/core/network/failures/failure.dart';
import 'package:style_me/core/network/failures/server_failure.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/core/utils/google_auth_service.dart';
import 'package:style_me/features/settings/data/models/report_category.dart';
import 'package:style_me/features/settings/data/models/report_request.dart';
import 'package:style_me/features/settings/domain/add_report_use_case.dart';
import 'package:style_me/features/settings/domain/delete_account_use_case.dart';
import 'package:style_me/features/settings/presentation/state/settings_state_holder.dart';

part 'settings_view_model.g.dart';

@riverpod
class SettingsViewModel extends _$SettingsViewModel {
  late final GetUserUseCase _getUserUseCase;
  late final GetCurrentThemeUseCase _getCurrentThemeUseCase;
  late final GetLanguageUseCase _getCurrentLangUseCase;
  late final LogoutUserUseCase _logoutUserUseCase;
  late final DeleteAccountUseCase _deleteAccountUseCase;
  late final AddReportUseCase _addReportUseCase;
  late final GoogleAuthService _googleAuthService;

  SettingsViewModel() {
    _getUserUseCase = getIt();
    _getCurrentThemeUseCase = getIt();
    _getCurrentLangUseCase = getIt();
    _logoutUserUseCase = getIt();
    _deleteAccountUseCase = getIt();
    _addReportUseCase = getIt();
    _googleAuthService = getIt();
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

  Future getUser() async {
    state = state.copyWith(isLoading: true);
    final Result<UserData> result = await _getUserUseCase();
    result.collect(
      (user) {
        state = state.copyWith(
          isLoading: false,
          userEmail: user.email,
          isUserFromGoogleSignIn: user.isFromGoogleSignIn,
        );
      },
      (failure) {
        ref.read(appGlobalViewModelProvider.notifier).showFailure(failure);
        state = state.copyWith(isLoading: false);
      },
    );
  }

  void changeDeleteDialogPassText(String text) {
    state = state.copyWith(
      deleteDialogState:
          state.deleteDialogState.copyWith(password: text, errorMessage: null),
    );
  }

  void toggleDeleteDialogPassVisibility() {
    state = state.copyWith(
        deleteDialogState: state.deleteDialogState.copyWith(
            isPasswordVisible: !state.deleteDialogState.isPasswordVisible));
  }

  Future logOut(Function onSuccess) async {
    await _logoutUserUseCase();
    onSuccess();
  }

  Future deleteAccount(Function onSuccess) async {
    state = state.copyWith(
        deleteDialogState: state.deleteDialogState.copyWith(isLoading: true));
    if (state.isUserFromGoogleSignIn) {
      await _googleAuthService.reAuthenticate();
    }
    final result =
        await _deleteAccountUseCase(state.deleteDialogState.password);
    result.collect((_) {
      state = state.copyWith(
          deleteDialogState:
              state.deleteDialogState.copyWith(isLoading: false, password: ""));
      _logoutUserUseCase();
      onSuccess();
    }, (failure) {
      _onDeleteFailure(failure);
    });
  }

  void _onDeleteFailure(Failure failure) {
    if (failure is ServerFailure &&
        failure.statusCode == HttpStatus.forbidden) {
      state = state.copyWith(
          deleteDialogState: state.deleteDialogState
              .copyWith(errorMessage: localizations.passwordWrong));
      return;
    }
    state = state.copyWith(
        deleteDialogState: state.deleteDialogState.copyWith(isLoading: false));
    ref.read(appGlobalViewModelProvider.notifier).showFailure(failure);
  }

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

  Future changeLanguage(Locale language, int settingIndex) async {
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

  Future submitIssueReport(String reportText) async {
    final result = await _addReportUseCase(
        ReportRequest(reportText, state.selectedCategory));
    final globalViewModel = ref.read(appGlobalViewModelProvider.notifier);
    result.collect((_) {
      globalViewModel.showSuccessInfo(localizations.reportSuccessMessage);
    }, (failure) {
      globalViewModel.showFailure(failure);
    });
  }

  void selectIssueReportCategory(ReportCategory category) {
    state = state.copyWith(selectedCategory: category);
  }

  @visibleForTesting
  SettingsViewModel.test(
    this._getUserUseCase,
    this._getCurrentThemeUseCase,
    this._getCurrentLangUseCase,
    this._logoutUserUseCase,
    this._deleteAccountUseCase,
    this._addReportUseCase,
  );
}
