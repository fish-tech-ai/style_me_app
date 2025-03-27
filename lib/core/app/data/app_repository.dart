import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:style_me/core/extensions/global_ext.dart';
import 'package:style_me/core/local/database.dart';
import 'package:style_me/core/utils/constants.dart';
import 'package:http/http.dart' as http;

class AppRepository {
  final SharedPreferences sharedPreferences;
  final AppDatabase database;

  AppRepository(this.sharedPreferences, this.database);

  String? getCurrentThemeName() {
    return sharedPreferences.getString(SharedPrefsConst.currentThemeKey);
  }

  void saveCurrentThemeName(String? value) {
    if (value == null) {
      sharedPreferences.remove(SharedPrefsConst.currentThemeKey);
      return;
    }
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
    sharedPreferences.setString(
        SharedPrefsConst.languageKey, language.toLanguageTag());
  }

  Future<Uint8List> fetchImageFrom(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception("${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      debugMessagePrint("Failed to load image: $e");
      throw Exception("Failed to load image");
    }
  }
}
