import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:style_me/core/app/presentation/ui_models/bottom_nav_item.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/navigation/app_page.dart';

part 'bottom_bar_state.freezed.dart';

@freezed
sealed class BottomBarState with _$BottomBarState {
  const factory BottomBarState({
    @Default(0) int selectedIndex,
    @Default(false) bool isVisible,
    @Default([]) List<BottomNavItem> items
  }) = _BottomBarState;

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
    ]..sort((a, b) {
      final aIndex = a.appPage.bottomNavIndex;
      final bIndex = b.appPage.bottomNavIndex;

      if (aIndex == null && bIndex == null) return 0;
      if (aIndex == null) return 1;
      if (bIndex == null) return -1;

      return aIndex.compareTo(bIndex);
    });
  }
}
