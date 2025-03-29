import 'package:style_me/core/lang/localizations_helper.dart';

enum ReportCategory {
  ONBOARDING,
  VIRTUAL_CLOSET_AND_FITTING_ROOM,
  HISTORY_AND_FAVORITE_OUTFITS,
  APP_SETTINGS,
  OTHER_ISSUES;

  String get text => switch(this) {
    ReportCategory.ONBOARDING => localizations.onboarding,
    ReportCategory.VIRTUAL_CLOSET_AND_FITTING_ROOM => localizations.virtualClosetAndFittingRoom,
    ReportCategory.HISTORY_AND_FAVORITE_OUTFITS => localizations.historyAndFavoriteOutfits,
    ReportCategory.APP_SETTINGS => localizations.appSettings,
    ReportCategory.OTHER_ISSUES => localizations.otherIssues,
  };
}