import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/navigation/app_page.dart';

part 'bottom_nav_item.freezed.dart';

@freezed
class BottomNavItem with _$BottomNavItem {
  const factory BottomNavItem({
    required String asset,
    required bool isSelected,
    required String label,
    required AppPage appPage,
  }) = _BottomNavItem;

  static List<BottomNavItem> getBottomNavItems() {
    return [
      BottomNavItem(
        asset: "assets/bottom_nav_icons/home.svg",
        isSelected: true,
        label: localizations.home,
          appPage: AppPage.homePage,
      ),
      BottomNavItem(
        asset: "assets/bottom_nav_icons/checkroom.svg",
        isSelected: false,
        label: localizations.checkroom,
        appPage: AppPage.checkroom,
      ),
      BottomNavItem(
        asset: "assets/bottom_nav_icons/wardrobe.svg",
        isSelected: false,
        label: localizations.wardrobe,
        appPage: AppPage.wardrobe,
      ),
      BottomNavItem(
        asset: "assets/bottom_nav_icons/settings.svg",
        isSelected: false,
        label: localizations.settings,
        appPage: AppPage.settings,
      ),
    ];
  }
}
