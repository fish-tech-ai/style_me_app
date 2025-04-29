import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/widget_ext.dart';
import 'package:style_me/core/views/input/search_text_field.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_category_enum.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_position_enum.dart';
import 'package:style_me/features/wardrobe/data/models/photo_item.dart';
import 'package:style_me/features/wardrobe/presentation/components/empty_page.dart';
import 'package:style_me/features/wardrobe/presentation/components/filtering_view.dart';
import 'package:style_me/features/wardrobe/presentation/components/photo_grid.dart';
import 'package:style_me/features/wardrobe/presentation/ui_models/clothing_list_search_parameters.dart';

class ClothesListPage extends StatefulWidget {
  final List<Clothing> clothes;
  final Function(PhotoItem) onItemClicked;
  final Function(ClothingListSearchParameters) onSearchParametersChanged;
  final Function()? onSearchClicked;
  final bool isLoading;
  final ScrollController? scrollController;

  const ClothesListPage({
    super.key,
    required this.clothes,
    required this.onItemClicked,
    required this.onSearchParametersChanged,
    this.scrollController,
    this.isLoading = false,
    this.onSearchClicked,
  });

  @override
  State<ClothesListPage> createState() => _ClothesListPageState();
}

class _ClothesListPageState extends State<ClothesListPage> {
  String searchText = "";
  ClothingPositionEnum? position;
  ClothingCategoryEnum category = ClothingCategoryEnum.ALL;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 4, left: 12, right: 12),
      child: Column(
        spacing: 12,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Flexible(fit: FlexFit.loose, child: _buildClothesPage(context)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      spacing: 6,
      children: [
        buildSearchTextField(),
        buildFilterView(),
      ],
    );
  }

  Widget buildSearchTextField() {
    return SearchTextField(
        text: searchText,
        onSearchClicked: widget.onSearchClicked,
        onTextChanged: (text) => onParametersChange(searchText: text),);
  }

  Widget buildFilterView() {
    return FilteringView(
        selectedPosition: position,
        selectedCategory: category,
        onFiltersClose: () => onParametersChange(
            position: null, category: ClothingCategoryEnum.ALL),
        onFiltersChange:
            (ClothingPositionEnum? position, ClothingCategoryEnum category) =>
                onParametersChange(
                  position: position,
                  category: category,
                ));
  }

  Widget _buildClothesPage(BuildContext context) {
    if (!widget.isLoading && widget.clothes.isEmpty) {
      return _buildEmptyPage();
    }
    return PhotoGrid(
      items: widget.clothes,
      scrollController: widget.scrollController,
      onItemClicked: (item) {
        widget.onItemClicked.call(item);
      },
    ).orLoading(widget.isLoading);
  }

  Widget _buildEmptyPage() {
    return SingleChildScrollView(
        controller: widget.scrollController, child: EmptyPage());
  }

  void onParametersChange({
    String? searchText,
    ClothingPositionEnum? position,
    ClothingCategoryEnum? category,
  }) {
    setState(() {
      this.searchText = searchText ?? this.searchText;
      this.position = searchText != null ? this.position : position;
      this.category = category ?? this.category;
    });
    widget.onSearchParametersChanged(
      ClothingListSearchParameters(
        searchText: this.searchText,
        position: this.position,
        category: this.category,
      ),
    );
  }
}
