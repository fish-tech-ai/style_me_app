import 'package:flutter/material.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/utils/constants.dart';

extension LocaleExt on Locale {
  String getLanguageText() {
    return toLanguageTag() == LanguageCodeConst.english
        ? localizations.languageEnglish
        : localizations.languagePolish;
  }
}