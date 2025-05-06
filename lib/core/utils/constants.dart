import 'package:flutter/material.dart';

abstract class SharedPrefsConst {
  static const currentThemeKey = "currentThemeKey";
  static const languageKey = "languageKey";
}

abstract class GlobalUiConst {
  static const double radiusSmall = 12;
  static const double radiusNormal = 12;
  static const double radiusLarge = 16;
  static const double radiusExtraLarge = 32;
  static BorderRadius borderRadiusSmall = BorderRadius.circular(radiusSmall);
  static BorderRadius borderRadiusNormal = BorderRadius.circular(radiusNormal);
  static BorderRadius borderRadiusLarge = BorderRadius.circular(radiusLarge);
  static BorderRadius borderRadiusExtraLarge =
      BorderRadius.circular(radiusExtraLarge);

  static const double paddingExtraSmall = 4;
  static const double paddingSmall = 8;
  static const double paddingMedium = 10;
  static const double paddingNormal = 12;
  static const double paddingLarge = 24;

  static const double defaultSystemNavBarHeight = 48;
}

abstract class RegexConst {
  static const passwordRegex =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$';
  static const emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static var fileExtension = RegExp(r'\.(jpg|jpeg|png|bmp|heif)$', caseSensitive: false);
}

abstract class NetworkHeaders {
  static const String authorization = "Authorization";
  static const String apiKey = "API-KEY";
}

abstract class LanguageCodeConst {
  static const String english = "en";
  static const String polish = "pl";
}

abstract class ImageTransformationsOptions {
  static const int compressedWidth = 600;
  static const int compressedQuality = 90;
}

abstract class CacheFileNames {
  static const String privacyPolicy = "privacy_policy.md";
  static const String termsOfUse = "terms_of_use.md";
}

