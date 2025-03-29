import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/utils/constants.dart';

class AppDropdownButtonOverlay {
  static OverlayEntry buildOverlay<T>({
    required BuildContext context,
    required List<T> items,
    required T selectedItem,
    required LayerLink layerLink,
    required Widget Function(T) itemBuilder,
    required Function() onTapOutside,
    required Function(T) onItemSelect,
  }) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final double contextMenuHeight = items.length * 45;
    final double contextMenuMaxHeight = 250;
    final mediaQuery = MediaQuery.of(context);
    final double screenHeight =
        mediaQuery.size.height - mediaQuery.viewInsets.bottom;
    final double spaceBelow = screenHeight - (offset.dy + size.height);
    final double spaceAbove = offset.dy;
    final bool showAbove =
        spaceBelow < contextMenuMaxHeight && spaceAbove > spaceBelow;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: () {
              onTapOutside();
            },
            child: Container(
              color: Colors.transparent,
            ),
          ),
          Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: layerLink,
              showWhenUnlinked: false,
              offset: showAbove
                  ? Offset(0, -contextMenuHeight - 4)
                  : Offset(0, size.height + 4),
              child: Material(
                elevation: 4.0,
                borderRadius: GlobalUiConst.borderRadiusNormal,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: contextMenuMaxHeight,
                  ),
                  decoration: BoxDecoration(
                    color: context.theme.dialogBackgroundColor,
                    border: Border.all(
                        color: context.colorScheme.primary, width: 1),
                    borderRadius: GlobalUiConst.borderRadiusNormal,
                  ),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: items
                        .map(
                          (item) => InkWell(
                            onTap: () {
                              onItemSelect(item);
                              //_toggleDropdown();
                            },
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color: item == selectedItem
                                    ? context.colorScheme.secondary
                                    : Colors.transparent,
                                borderRadius: GlobalUiConst.borderRadiusNormal,
                              ),
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: itemBuilder(item),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
