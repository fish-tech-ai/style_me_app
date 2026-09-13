import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:style_me/core/navigation/app_page.dart';

part 'bottom_nav_item.freezed.dart';

@freezed
sealed class BottomNavItem with _$BottomNavItem {
  const factory BottomNavItem({
    required String asset,
    required bool isSelected,
    required String label,
    required AppPage appPage,
  }) = _BottomNavItem;
}
