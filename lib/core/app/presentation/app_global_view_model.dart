import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:style_me/core/app/domain/usecases/get_current_theme_use_case.dart';
import 'package:style_me/core/app/domain/usecases/save_current_theme_use_case.dart';
import 'package:style_me/core/app/presentation/app_global_state_holder.dart';
import 'package:style_me/core/app/presentation/ui_models/banner_message.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/core/extensions/global_ext.dart';
import 'package:style_me/core/network/connection.dart';
import 'package:style_me/core/network/failures/failure.dart';
import 'package:style_me/core/utils/deep_link_manager.dart';
import 'package:style_me/features/auth/domain/confirm_email_use_case.dart';

part 'app_global_view_model.g.dart';

@riverpod
class AppGlobalViewModel extends _$AppGlobalViewModel {
  late final GetCurrentThemeUseCase _getCurrentThemeUseCase;
  late final SaveCurrentThemeUseCase _saveCurrentThemeUseCase;
  late final ConfirmEmailUseCase _confirmEmailUseCase;
  late final DeepLinkManager _deepLinkManager;
  late final Connection _connection;

  AppGlobalViewModel() {
    _getCurrentThemeUseCase = getIt();
    _saveCurrentThemeUseCase = getIt();
    _confirmEmailUseCase = getIt();
    _connection = getIt();
    _deepLinkManager = getIt();
  }

  @override
  AppGlobalStateHolder build() {
    _monitorConnection();
    return AppGlobalStateHolder(currentTheme: _getCurrentThemeUseCase());
  }

  void _monitorConnection() {
    _connection.connectionStream.listen((bool isConnected) {
      state = state.copyWith(isConnected: isConnected);
    });
  }

  void showFailure(Failure failure) async {
    state =
        state.copyWith(bannerMessage: BannerMessage(failure.toString(), true));
    await Future.delayed(Duration(seconds: 5));
    state = state.copyWith(bannerMessage: null);
  }

  void showSuccessInfo(String message) async {
    state = state.copyWith(bannerMessage: BannerMessage(message, false));
    await Future.delayed(Duration(seconds: 5));
    state = state.copyWith(bannerMessage: null);
  }

  void getCurrentTheme() {
    state = state.copyWith(currentTheme: _getCurrentThemeUseCase());
  }

  void changeTheme(Brightness brightness) {
    _saveCurrentThemeUseCase(brightness);
    state = state.copyWith(currentTheme: brightness);
  }

  Future initializeAndHandleDeepLinks({
    required Function(String token) navigateToPasswordReset,
    required String confirmationSuccessMessage,
  }) async {
    await _deepLinkManager.initializeAndHandleDeepLinks(
      navigateToPasswordReset,
      (String token) {
        _confirmEmail(token, confirmationSuccessMessage);
      },
    );
  }

  Future _confirmEmail(String token, String confirmationSuccessMessage) async {
    final result = await _confirmEmailUseCase(token);
    result.collect((_) {
      showSuccessInfo(confirmationSuccessMessage);
    }, (failure) {
      showFailure(failure);
    });
  }
}
