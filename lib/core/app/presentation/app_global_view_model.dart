import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:style_me/core/app/domain/usecases/get_current_theme_use_case.dart';
import 'package:style_me/core/app/domain/usecases/get_language_use_case.dart';
import 'package:style_me/core/app/domain/usecases/save_current_theme_use_case.dart';
import 'package:style_me/core/app/domain/usecases/set_language_use_case.dart';
import 'package:style_me/core/app/presentation/app_global_state_holder.dart';
import 'package:style_me/core/app/presentation/ui_models/banner_message.dart';
import 'package:style_me/core/app/presentation/ui_models/bottom_bar_state.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/network/connection.dart';
import 'package:style_me/core/network/failures/failure.dart';
import 'package:style_me/core/utils/deep_link_manager.dart';
import 'package:style_me/features/auth/domain/confirm_email_use_case.dart';

part 'app_global_view_model.g.dart';

@riverpod
class AppGlobalViewModel extends _$AppGlobalViewModel {
  late final GetCurrentThemeUseCase _getCurrentThemeUseCase;
  late final SaveCurrentThemeUseCase _saveCurrentThemeUseCase;
  late final GetLanguageUseCase _getLanguageUseCase;
  late final SetLanguageUseCase _setLanguageUseCase;
  late final ConfirmEmailUseCase _confirmEmailUseCase;
  late final DeepLinkManager _deepLinkManager;
  late final Connection _connection;

  AppGlobalViewModel() {
    _getCurrentThemeUseCase = getIt();
    _saveCurrentThemeUseCase = getIt();
    _getLanguageUseCase = getIt();
    _setLanguageUseCase = getIt();
    _confirmEmailUseCase = getIt();
    _connection = getIt();
    _deepLinkManager = getIt();
  }

  @override
  AppGlobalStateHolder build() {
    _monitorConnection();
    return AppGlobalStateHolder(
        currentTheme: _getCurrentThemeUseCase(), lang: _getLanguageUseCase());
  }

  void _monitorConnection() {
    _connection.connectionStream.listen((bool isConnected) {
      state = state.copyWith(isConnected: isConnected);
    });
  }

  void initBottomNavItems() {
    state = state.copyWith(
        bottomBarState: BottomBarState(
      items: BottomBarState.getBottomNavItems(),
    ));
  }

  void showFailure(Failure failure) async {
    state = state.copyWith(
        bannerMessage: BannerMessage(
            message: failure.toString(), isError: true, isVisible: true));
    await Future.delayed(Duration(seconds: 5));
    state = state.copyWith(
        bannerMessage: state.bannerMessage.copyWith(isVisible: false));
  }

  void showErrorMessage(String message) async {
    state = state.copyWith(
        bannerMessage:
            BannerMessage(message: message, isError: true, isVisible: true));
    await Future.delayed(Duration(seconds: 5));
    state = state.copyWith(
        bannerMessage: state.bannerMessage.copyWith(isVisible: false));
  }

  void showSuccessInfo(String message) async {
    state = state.copyWith(
        bannerMessage:
            BannerMessage(message: message, isError: false, isVisible: true));
    await Future.delayed(Duration(seconds: 5));
    state = state.copyWith(
        bannerMessage: state.bannerMessage.copyWith(isVisible: false));
  }

  void changeTheme(Brightness? brightness) {
    _saveCurrentThemeUseCase(brightness);
    state = state.copyWith(currentTheme: brightness);
  }

  void changeLanguage(Locale lang) {
    _setLanguageUseCase(lang);
    final selectedBottomNavItem =
        state.bottomBarState.items.indexWhere((item) => item.isSelected);
    state = state.copyWith(
      lang: lang,
      bottomBarState: state.bottomBarState
          .copyWith(items: BottomBarState.getBottomNavItems()),
    );
    selectBottomNavItem(selectedBottomNavItem);
  }

  Future initializeAndHandleDeepLinks({
    required Function(String token) navigateToPasswordReset,
  }) async {
    await _deepLinkManager.initializeAndHandleDeepLinks(
      navigateToPasswordReset,
      (String token) => _confirmEmail(token),
      () => showErrorMessage(localizations.tokenExpiredMessage),
    );
  }

  Future _confirmEmail(String token) async {
    final result = await _confirmEmailUseCase(token);
    result.collect((_) {
      showSuccessInfo(localizations.confirmationSuccess);
    }, (failure) {
      showFailure(failure);
    });
  }

  void selectBottomNavItem(int selectedIndex) {
    state = state.copyWith(
      bottomBarState: state.bottomBarState.copyWith(
        items: state.bottomBarState.items.mapIndexed((index, item) {
          return item.copyWith(isSelected: selectedIndex == index);
        }).toList(),
      ),
    );
  }

  void setBottomNavBarVisibility(bool isVisible) {
    state = state.copyWith(
        bottomBarState: state.bottomBarState.copyWith(isVisible: isVisible));
  }

  @visibleForTesting
  AppGlobalViewModel.test(
      this._getCurrentThemeUseCase,
      this._saveCurrentThemeUseCase,
      this._getLanguageUseCase,
      this._setLanguageUseCase,
      this._confirmEmailUseCase,
      this._deepLinkManager,
      this._connection);
}
