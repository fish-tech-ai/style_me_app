import 'package:flutter/material.dart';
import 'package:style_me/core/app/data/app_repository.dart';

class SaveCurrentThemeUseCase {
  final AppRepository appRepository;

  SaveCurrentThemeUseCase(this.appRepository);

  void call(Brightness theme) {
    appRepository.saveCurrentThemeName(theme.name);
  }
}