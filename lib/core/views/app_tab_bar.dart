import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/extensions/list_ext.dart';
import 'package:style_me/core/utils/constants.dart';

class AppTabBar extends StatefulWidget {
  final TabController controller;
  final List<Widget> tabs;

  const AppTabBar({super.key, required this.controller, required this.tabs});

  @override
  State<AppTabBar> createState() => _AppTabBarState();
}

class _AppTabBarState extends State<AppTabBar> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.controller.index;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabCount = widget.tabs.length;
          final tabWidth = constraints.maxWidth / tabCount;
          return Stack(
            children: [
              buildAnimatedIndicator(tabWidth: tabWidth),
              IntrinsicHeight(
                child: Row(
                  children: widget.tabs
                      .mapIndexed<Widget>(buildTab)
                      .toList()
                      .addSeparators(buildDivider()),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildTab(int index, Widget tab) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTabClicked(index),
        child: Center(
          child: IntrinsicWidth(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: tab,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDivider() {
    return Container(
      height: 65,
      width: 1,
      color: context.colorScheme.primary,
    );
  }

  void onTabClicked(int index) {
    widget.controller.animateTo(index);
    setState(() {
      selectedIndex = index;
    });
  }

  Widget buildAnimatedIndicator({required double tabWidth}) {
    return AnimatedBuilder(
      animation: widget.controller.animation!,
      builder: (context, child) {
        double animationValue = widget.controller.animation!.value;
        return Positioned(
          left: animationValue * tabWidth,
          top: 4,
          bottom: 4,
          width: tabWidth,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: GlobalUiConst.borderRadiusNormal,
              color: context.colorScheme.primaryContainer,
            ),
          ),
        );
      },
    );
  }
}
