import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocalizationHelper {
  static late AppLocalizations instance;

  static void init(BuildContext context) {
    instance = AppLocalizations.of(context)!;
  }
}

AppLocalizations get localizations => LocalizationHelper.instance;