import 'package:style_me/core/lang/app_localizations.dart';

class LocalizationHelper {
  static late AppLocalizations instance;

  static void init(AppLocalizations localizations) {
    instance = localizations;
  }
}

AppLocalizations get localizations => LocalizationHelper.instance;