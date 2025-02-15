import 'package:flutter/material.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/utils/constants.dart';

class AppSettings {
  final Locale language;
  final Brightness theme;

  AppSettings(this.language, this.theme);

  String getThemeText() {
    return theme == Brightness.dark
        ? localizations.themeDark
        : localizations.themeLight;
  }

  String getLanguageText() {
    return language.toLanguageTag() == LanguageCodeConst.english
        ? localizations.themeDark
        : localizations.themeLight;
  }
}
