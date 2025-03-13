import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:style_me/core/extensions/widget_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/views/input/search_text_field.dart';
import 'package:style_me/features/wardrobe/presentation/components/filtering_view.dart';
import 'package:style_me/features/wardrobe/presentation/components/photo_grid.dart';
import 'package:style_me/features/wardrobe/presentation/state/wardrobe_state_holder.dart';
import 'package:style_me/features/wardrobe/presentation/state/viewmodels/wardrobe_view_model.dart';
import 'package:style_me/features/wardrobe/data/models/photo_item.dart';

class WardrobePage extends ConsumerWidget {
  const WardrobePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(wardrobeViewModelProvider);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            spacing: 6,
            children: [
              buildSearchTextField(ref),
              buildFilterView(ref),
            ],
          ),
          _buildClothesPage(state),
        ],
      ),
    );
  }

  Widget buildSearchTextField(WidgetRef ref) {
    final WardrobeStateHolder state = ref.watch(wardrobeViewModelProvider);
    final WardrobeViewModel viewModel =
        ref.read(wardrobeViewModelProvider.notifier);
    return SearchTextField(
      text: state.searchText,
      onTextChanged: viewModel.onSearchTextChanged,
    );
  }

  Widget buildFilterView(WidgetRef ref) {
    final WardrobeStateHolder state = ref.watch(wardrobeViewModelProvider);
    final WardrobeViewModel viewModel =
        ref.read(wardrobeViewModelProvider.notifier);
    return FilteringView(
      selectedPosition: state.filterPosition,
      selectedCategory: state.filterCategory,
      onFiltersClose: () {
        viewModel.clearFilters();
      },
      onFiltersChange: (clothingPositionEnum, clothingCategoryEnum) {
        viewModel.onFilterChanged(clothingPositionEnum, clothingCategoryEnum);
      },
    );
  }

  Widget _buildClothesPage(WardrobeStateHolder state) {
    if (!state.isLoading && state.clothes.isEmpty) {
      return _buildEmptyPage();
    }
    return Expanded(
      child: PhotoGrid(
        items: state.clothes,
        onItemClicked: (PhotoItem photoItem) {},
      ).orLoading(state.isLoading),
    );
  }

  Widget _buildEmptyPage() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 42),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/no_clothes.svg"),
          SizedBox(height: 24),
          Text(
            localizations.nothingFound,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 6),
          Text(
            localizations.nothingFoundSubText,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
