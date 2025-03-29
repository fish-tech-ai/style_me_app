import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:style_me/core/app/data/app_repository.dart';
import 'package:style_me/core/local/database.dart';
import 'package:style_me/core/utils/constants.dart';

class MockDatabase extends Fake implements AppDatabase {}

void main() {
  late SharedPreferences prefs;
  late AppRepository repo;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    repo = AppRepository(prefs, MockDatabase());
  });

  group('AppRepository', () {
    test('saveCurrentThemeName saves and retrieves theme name', () {
      repo.saveCurrentThemeName('dark');
      expect(prefs.getString(SharedPrefsConst.currentThemeKey), 'dark');
      expect(repo.getCurrentThemeName(), 'dark');
    });

    test('saveCurrentThemeName removes value when null', () {
      repo.saveCurrentThemeName('light');
      repo.saveCurrentThemeName(null);
      expect(prefs.containsKey(SharedPrefsConst.currentThemeKey), false);
    });

    test('getLanguage returns null when not set', () {
      expect(repo.getLanguage(), isNull);
    });

    test('saveLanguage and getLanguage work correctly', () {
      final locale = Locale('en');
      repo.saveLanguage(locale);

      final saved = prefs.getString(SharedPrefsConst.languageKey);
      expect(saved, 'en');

      final retrieved = repo.getLanguage();
      expect(retrieved?.languageCode, 'en');
    });
  });
}
