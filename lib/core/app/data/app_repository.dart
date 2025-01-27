import 'package:shared_preferences/shared_preferences.dart';
import 'package:style_me/core/utils/constants.dart';

class AppRepository {
  final SharedPreferences sharedPreferences;

  AppRepository(this.sharedPreferences);

  String? getCurrentThemeName() {
    return sharedPreferences.getString(SharedPrefsConst.currentThemeKey);
  }

  void saveCurrentThemeName(String value) {
    sharedPreferences.setString(SharedPrefsConst.currentThemeKey, value);
  }
}
