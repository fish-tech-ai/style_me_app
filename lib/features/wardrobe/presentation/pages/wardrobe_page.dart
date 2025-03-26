import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/views/app_tab_bar.dart';
import 'package:style_me/features/wardrobe/presentation/pages/clothes_list_page.dart';
import 'package:style_me/features/wardrobe/presentation/pages/user_photos_list_page.dart';
import 'package:style_me/features/wardrobe/presentation/state/viewmodels/wardrobe_view_model.dart';

class WardrobePage extends ConsumerStatefulWidget {
  const WardrobePage({super.key});

  @override
  ConsumerState<WardrobePage> createState() => _WardrobePageState();
}

class _WardrobePageState extends ConsumerState<WardrobePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2, vsync: this, animationDuration: Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(wardrobeViewModelProvider);
    final viewModel = ref.watch(wardrobeViewModelProvider.notifier);
    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        spacing: 12,
        children: [
          AppTabBar(controller: _tabController, tabs: [
            buildTabBarItem(
              text: localizations.yourClothes,
              icon: SvgPicture.asset(
                "assets/apparel_icon.svg",
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(
                  context.colorScheme.onPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            buildTabBarItem(
              text: localizations.yourPhotos,
              icon: Icon(
                Icons.accessibility_new_rounded,
                color: context.colorScheme.onPrimary,
              ),
            ),
          ]),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ClothesListPage(
                  state: state,
                  onFilterClosed: viewModel.clearFilters,
                  onFiltersChange: viewModel.onFilterChanged,
                  onTextChanged: viewModel.onSearchTextChanged,
                  onModifyResult: viewModel.onClothingModifyResult,
                ),
                UserPhotosListPage()
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildTabBarItem({required String text, required Widget icon}) {
    return Row(
      spacing: 4,
      children: [
        icon,
        Text(
          text,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
