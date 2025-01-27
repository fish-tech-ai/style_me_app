import 'package:flutter/material.dart';
import 'package:style_me/core/app/data/app_repository.dart';

class GetCurrentThemeUseCase {
  final AppRepository appRepository;

  GetCurrentThemeUseCase(this.appRepository);

  Brightness? call() {
    final currentThemeName = appRepository.getCurrentThemeName();
    if (currentThemeName == null) {
      return null;
    }
    return Brightness.values.byName(currentThemeName);
  }
}