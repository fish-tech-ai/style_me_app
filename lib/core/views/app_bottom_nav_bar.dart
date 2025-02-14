import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/app/presentation/ui_models/bottom_bar_state.dart';
import 'package:style_me/core/app/presentation/ui_models/bottom_nav_item.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/extensions/widget_ext.dart';

class AppBottomNavBar extends ConsumerWidget {
  final GoRouter router;

  const AppBottomNavBar(this.router, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BottomBarState state = ref.watch(
        appGlobalViewModelProvider.select((state) => state.bottomBarState));
    return Container(
      color: context.colorScheme.surface,
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      child: Row(
        spacing: 4,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ...state.items.mapIndexed(
            (index, navItem) =>
                _buildNavItem(ref: ref, item: navItem, index: index),
          )
        ],
      ),
    ).orEmpty(!state.isVisible);
  }

  Widget _buildNavItem({
    required WidgetRef ref,
    required BottomNavItem item,
    required int index,
  }) {
    final ColorScheme colorScheme = ref.context.colorScheme;
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GestureDetector(
          onTap: () {
            ref
                .read(appGlobalViewModelProvider.notifier)
                .selectBottomNavItem(index);
            router.push(item.appPage.path);
          },
          child: Container(
            color: item.isSelected ? colorScheme.secondary : Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  item.asset,
                  colorFilter: ColorFilter.mode(
                    item.isSelected
                        ? colorScheme.onSurface
                        : colorScheme.onSecondary,
                    BlendMode.srcIn,
                  ),
                ),
                Text(
                  item.label.toUpperCase(),
                  style: TextStyle(
                      color: item.isSelected
                          ? colorScheme.onSurface
                          : colorScheme.onSecondary,
                      fontSize: 12),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
