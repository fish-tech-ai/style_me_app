import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:style_me/core/app/presentation/ui_models/bottom_nav_item.dart';

part 'bottom_bar_state.freezed.dart';

@freezed
class BottomBarState with _$BottomBarState {
  const factory BottomBarState({
    @Default(0) int selectedIndex,
    @Default(false) bool isVisible,
    @Default([]) List<BottomNavItem> items
  }) = _BottomBarState;
}
