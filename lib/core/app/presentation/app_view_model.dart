import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:style_me/core/app/domain/usecases/get_current_theme_use_case.dart';
import 'package:style_me/core/app/domain/usecases/save_current_theme_use_case.dart';
import 'package:style_me/core/app/presentation/app_state_holder.dart';
import 'package:style_me/core/di/get_it.dart';

part 'app_view_model.g.dart';

@riverpod
class AppViewModel extends _$AppViewModel {
  late final GetCurrentThemeUseCase _getCurrentThemeUseCase;
  late final SaveCurrentThemeUseCase _saveCurrentThemeUseCase;

  AppViewModel() {
    _getCurrentThemeUseCase = getIt();
    _saveCurrentThemeUseCase = getIt();
  }

  @override
  AppStateHolder build() {
    return AppStateHolder(currentTheme: _getCurrentThemeUseCase());
  }

  void getCurrentTheme() {
    state = state.copyWith(_getCurrentThemeUseCase());
  }

  void changeTheme(Brightness brightness) {
    _saveCurrentThemeUseCase(brightness);
    state = state.copyWith(brightness);
  }
}