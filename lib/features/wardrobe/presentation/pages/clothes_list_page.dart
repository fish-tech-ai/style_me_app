import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:style_me/core/extensions/widget_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/views/input/search_text_field.dart';
import 'package:style_me/features/wardrobe/data/models/clothing_category_enum.dart';
import 'package:style_me/features/wardrobe/data/models/clothing_position_enum.dart';
import 'package:style_me/features/wardrobe/data/models/photo_item.dart';
import 'package:style_me/features/wardrobe/presentation/components/filtering_view.dart';
import 'package:style_me/features/wardrobe/presentation/components/photo_grid.dart';
import 'package:style_me/features/wardrobe/presentation/state/wardrobe_state_holder.dart';

class ClothesListPage extends StatelessWidget {
  final WardrobeStateHolder state;
  final Function() onFilterClosed;
  final Function(ClothingPositionEnum?, ClothingCategoryEnum) onFiltersChange;
  final Function(String) onTextChanged;

  const ClothesListPage(
      {required this.state,
      super.key,
      required this.onFilterClosed,
      required this.onFiltersChange,
      required this.onTextChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 4),
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
          _buildClothesPage(),
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

  Widget _buildClothesPage() {
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
