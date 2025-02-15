import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:style_me/core/local/database.dart';
import 'package:style_me/core/utils/constants.dart';

class AppRepository {
  final SharedPreferences sharedPreferences;
  final AppDatabase database;

  AppRepository(this.sharedPreferences, this.database);

  String? getCurrentThemeName() {
    return sharedPreferences.getString(SharedPrefsConst.currentThemeKey);
  }

  void saveCurrentThemeName(String value) {
    sharedPreferences.setString(SharedPrefsConst.currentThemeKey, value);
  }

  Locale? getLanguage() {
    final language = sharedPreferences.getString(SharedPrefsConst.languageKey);
    if (language == null) {
      return null;
    }
    return Locale(language);
  }

  void saveLanguage(Locale language) {
    sharedPreferences.setString(SharedPrefsConst.languageKey, language.toLanguageTag());
  }
}
