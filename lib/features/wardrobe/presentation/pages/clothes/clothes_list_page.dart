import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/extensions/widget_ext.dart';
import 'package:style_me/core/navigation/app_page.dart';
import 'package:style_me/core/views/input/search_text_field.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_category_enum.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_position_enum.dart';
import 'package:style_me/features/wardrobe/data/models/photo_item.dart';
import 'package:style_me/features/wardrobe/presentation/components/empty_page.dart';
import 'package:style_me/features/wardrobe/presentation/components/filtering_view.dart';
import 'package:style_me/features/wardrobe/presentation/components/photo_grid.dart';
import 'package:style_me/features/wardrobe/presentation/state/states/wardrobe_state_holder.dart';
import 'package:style_me/features/wardrobe/presentation/ui_models/photo_with_action.dart';

class ClothesListPage extends StatelessWidget {
  final WardrobeStateHolder state;
  final Function() onFilterClosed;
  final Function(ClothingPositionEnum?, ClothingCategoryEnum) onFiltersChange;
  final Function(String) onTextChanged;
  final Function(PhotoWithAction) onModifyResult;

  const ClothesListPage({
    super.key,
    required this.state,
    required this.onFilterClosed,
    required this.onFiltersChange,
    required this.onTextChanged,
    required this.onModifyResult,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 4, left: 12, right: 12),
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            spacing: 6,
            children: [
              buildSearchTextField(),
              buildFilterView(),
            ],
          ),
          _buildClothesPage(context),
        ],
      ),
    );
  }

  Widget buildSearchTextField() {
    return SearchTextField(
      text: state.searchText,
      onTextChanged: onTextChanged,
    );
  }

  Widget buildFilterView() {
    return FilteringView(
      selectedPosition: state.filterPosition,
      selectedCategory: state.filterCategory,
      onFiltersClose: onFilterClosed,
      onFiltersChange: onFiltersChange,
    );
  }

  Widget _buildClothesPage(BuildContext context) {
    if (!state.isClothesLoading && state.clothes.isEmpty) {
      return EmptyPage();
    }
    return Expanded(
      child: PhotoGrid(
        items: state.clothes,
        onItemClicked: (item) => onItemClicked(item, context),
      ).orLoading(state.isClothesLoading),
    );
  }

  void onItemClicked(PhotoItem photoItem, BuildContext context) async {
    final PhotoWithAction? clothingWithAction = await context
        .push(AppPage.editClothingPage.path, extra: photoItem as Clothing);
    if (clothingWithAction != null) {
      onModifyResult(clothingWithAction);
    }
  }
}
