import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:style_me/core/app/domain/usecases/get_current_theme_use_case.dart';
import 'package:style_me/core/app/domain/usecases/save_current_theme_use_case.dart';
import 'package:style_me/core/app/presentation/app_state_holder.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/core/network/connection.dart';
import 'package:style_me/core/network/failures/failure.dart';

part 'app_view_model.g.dart';

@riverpod
class AppViewModel extends _$AppViewModel {
  late final GetCurrentThemeUseCase _getCurrentThemeUseCase;
  late final SaveCurrentThemeUseCase _saveCurrentThemeUseCase;
  late final Connection _connection;

  AppViewModel() {
    _getCurrentThemeUseCase = getIt();
    _saveCurrentThemeUseCase = getIt();
    _connection = getIt();
  }

  @override
  AppStateHolder build() {
    _monitorConnection();
    return AppStateHolder(currentTheme: _getCurrentThemeUseCase());
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
