import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:style_me/core/theme/custom_colors.dart';

extension AppLocalizationsExt on BuildContext {
  AppLocalizations get localizations => AppLocalizations.of(this)!;
}

extension UiExt on BuildContext {
  double getScreenHeight() => MediaQuery.of(this).size.height;

  double getScreenWidth() => MediaQuery.of(this).size.width;

  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  CustomColors get customColors => Theme.of(this).extension<CustomColors>()!;
}
