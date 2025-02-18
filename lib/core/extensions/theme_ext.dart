import 'package:flutter/material.dart';
import 'package:style_me/core/lang/localizations_helper.dart';

extension ThemeLocalization on Brightness? {
  String getThemeText() {
    if (this == null) {
      return localizations.followSystemTheme;
    }
    return this == Brightness.dark
        ? localizations.themeDark
        : localizations.themeLight;
  }
}
