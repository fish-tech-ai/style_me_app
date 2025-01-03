import 'package:flutter/material.dart';
import 'package:style_me/core/theme/colors.dart';

class ThemeManager {
  final ThemeData appThemeDark = _getAppTheme(AppColorsDark());

  final ThemeData appThemeLight = _getAppTheme(AppColorsLight());

  static ThemeData _getAppTheme(AppColorsMixin appColors) {
    return ThemeData(
        colorScheme: ColorScheme(
          primary: appColors.accent,
          primaryContainer: appColors.accentA20,
          secondary: appColors.surface,
          secondaryContainer: appColors.surfaceA90,
          surface: appColors.background,
          error: appColors.danger,
          onPrimary: appColors.textOnAccent,
          onSecondary: appColors.textSecondary,
          onSurface: appColors.text,
          onError: appColors.dangerSurface,
          brightness: appColors.brightness,
        ),
        scaffoldBackgroundColor: appColors.background,
        dialogBackgroundColor: appColors.backgroundDarker,
        disabledColor: appColors.disabled,
        hintColor: appColors.textDisabled,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: appColors.text),
          bodyMedium: TextStyle(color: appColors.textSecondary),
          bodySmall: TextStyle(color: appColors.textDisabled),
        ),
        buttonTheme: ButtonThemeData(
            buttonColor: appColors.accent,
            disabledColor: appColors.disabled,
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(12)))),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: appColors.accent,
            backgroundColor: appColors.accentA20,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: appColors.accent,
            foregroundColor: appColors.textOnAccent,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: appColors.accent,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: appColors.accent,
            foregroundColor: appColors.textOnAccent),
        inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)))),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: appColors.background,
          selectedItemColor: appColors.accent,
          unselectedItemColor: appColors.textSecondary,
        ),
        useMaterial3: true);
  }

  ThemeMode getModeBy(Brightness? currentTheme) {
    switch (currentTheme) {
      case null:
        return ThemeMode.system;
      case Brightness.dark:
        return ThemeMode.dark;
      case Brightness.light:
        return ThemeMode.light;
    }
  }
}
