import 'package:flutter/material.dart';
import 'package:style_me/core/theme/colors.dart';
import 'package:style_me/core/theme/custom_colors.dart';
import 'package:style_me/core/utils/constants.dart';

class ThemeManager {
  final ThemeData appThemeDark = _getAppTheme(AppColorsDark());

  final ThemeData appThemeLight = _getAppTheme(AppColorsLight());

  static ThemeData _getAppTheme(AppColorsMixin appColors) {
    return ThemeData(
        fontFamily: 'Inter',
        extensions: <ThemeExtension<CustomColors>>[
          CustomColors(
            backgroundA85: appColors.backgroundA85,
            dangerA20: appColors.dangerA20,
            accentA80: appColors.accentA80,
            googleButtonBackgroundColor: appColors.googleButtonBackgroundColor,
          ),
        ],
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
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.transparent,
        ),
        scaffoldBackgroundColor: appColors.background,
        dialogBackgroundColor: appColors.backgroundDarker,
        disabledColor: appColors.disabled,
        hintColor: appColors.textDisabled,
        buttonTheme: ButtonThemeData(
            buttonColor: appColors.accent,
            disabledColor: appColors.disabled,
            shape: RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: GlobalUiConst.borderRadiusNormal)),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
                  foregroundColor: appColors.accent,
                  backgroundColor: appColors.accentA20,
                  disabledBackgroundColor: appColors.disabled,
                  disabledForegroundColor: appColors.textDisabled,
                  textStyle: TextStyle(
                      fontWeight: FontWeight.w500, fontFamily: 'Inter'),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: appColors.accent),
                      borderRadius: GlobalUiConst.borderRadiusNormal))
              .merge(ButtonStyle(
            side: WidgetStateProperty.resolveWith<BorderSide?>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  return BorderSide(color: appColors.textDisabled);
                }
                return BorderSide(color: appColors.accent);
              },
            ),
          )),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: appColors.accent,
              foregroundColor: appColors.textOnAccent,
              textStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: appColors.text,
                  fontFamily: 'Inter'),
              shape: RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: GlobalUiConst.borderRadiusNormal)),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: appColors.accent,
              textStyle:
                  TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Inter'),
              shape: RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: GlobalUiConst.borderRadiusNormal)),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: appColors.accent,
            foregroundColor: appColors.textOnAccent),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: appColors.textSecondary),
          floatingLabelStyle: TextStyle(color: appColors.accent),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appColors.accent),
            borderRadius: GlobalUiConst.borderRadiusNormal,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appColors.accent, width: 2),
            borderRadius: GlobalUiConst.borderRadiusNormal,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appColors.danger),
            borderRadius: GlobalUiConst.borderRadiusNormal,
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appColors.danger, width: 2),
            borderRadius: GlobalUiConst.borderRadiusNormal,
          ),
        ),
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
