import 'package:style_me/core/lang/localizations_helper.dart';

enum HomeGridType {
  favorites,
  recentOutfits;

  String getTitle() {
    switch (this) {
      case HomeGridType.favorites:
        return localizations.homeSectionFavorites;
      case HomeGridType.recentOutfits:
        return localizations.homeSectionRecentOutfits;
    }
  }
}
