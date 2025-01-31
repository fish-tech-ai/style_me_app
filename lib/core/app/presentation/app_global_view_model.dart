import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:style_me/core/app/domain/usecases/get_current_theme_use_case.dart';
import 'package:style_me/core/app/domain/usecases/save_current_theme_use_case.dart';
import 'package:style_me/core/app/presentation/app_global_state_holder.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/core/network/connection.dart';
import 'package:style_me/core/network/failures/failure.dart';
import 'package:style_me/core/utils/token_authenticator.dart';

part 'app_global_view_model.g.dart';

@riverpod
class AppGlobalViewModel extends _$AppGlobalViewModel {
  late final GetCurrentThemeUseCase _getCurrentThemeUseCase;
  late final SaveCurrentThemeUseCase _saveCurrentThemeUseCase;
  late final TokenAuthenticator _tokenAuthenticator;
  late final Connection _connection;

  AppGlobalViewModel() {
    _getCurrentThemeUseCase = getIt();
    _saveCurrentThemeUseCase = getIt();
    _tokenAuthenticator = getIt();
    _connection = getIt();
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
    state = state.copyWith(failure: failure);
    await Future.delayed(Duration(seconds: 5));
    state = state.copyWith(failure: null);
  }

  void getCurrentTheme() {
    state = state.copyWith(currentTheme: _getCurrentThemeUseCase());
  }

  void changeTheme(Brightness brightness) {
    _saveCurrentThemeUseCase(brightness);
    state = state.copyWith(currentTheme: brightness);
  }
}
