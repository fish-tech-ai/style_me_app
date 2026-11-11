import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/navigation/app_page.dart';
import 'package:style_me/core/views/buttons/floating/floating_add_clothing_button.dart';
import 'package:style_me/core/views/default_loading_page.dart';
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
  final bool shouldShowAddButton;
  final ScrollController? scrollController;

  const ClothesListPage({
    super.key,
    required this.clothes,
    required this.onItemClicked,
    required this.onSearchParametersChanged,
    this.scrollController,
    this.isLoading = false,
    this.shouldShowAddButton = true,
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
      child: ClipRect(
        child: CustomMultiChildLayout(
          delegate: _ClothesListLayoutDelegate(spacing: 12),
          children: [
            LayoutId(
              id: _ClothesListSlot.header,
              child: _buildHeader(),
            ),
            LayoutId(
              id: _ClothesListSlot.content,
              child: _buildClothesPage(context),
            ),
          ],
        ),
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
      onTextChanged: (text) => onParametersChange(searchText: text),
    );
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
      return _buildWithAddButtonIfNeeded(child: _buildEmptyPage());
    }
    return _buildWithAddButtonIfNeeded(
      child: widget.isLoading
          ? SingleChildScrollView(
              controller: widget.scrollController,
              child: SizedBox(
                height: 200,
                child: DefaultLoading(),
              ),
            )
          : PhotoGrid(
              items: widget.clothes,
              scrollController: widget.scrollController,
              bottomInset: widget.shouldShowAddButton ? 72 : 0,
              onItemClicked: (item) {
                widget.onItemClicked.call(item);
              },
            ),
    );
  }

  Widget _buildEmptyPage() {
    return SingleChildScrollView(
      controller: widget.scrollController,
      child: EmptyPage(
        title: localizations.nothingFound,
        subTitle: localizations.nothingFoundSubText,
      ),
    );
  }

  Widget _buildWithAddButtonIfNeeded({required Widget child}) {
    if (widget.shouldShowAddButton) {
      return Stack(
        fit: StackFit.expand,
        children: [
          child,
          Positioned(
            bottom: 12,
            right: 12,
            child: FloatingAddClothingButton(
              onClick: () {
                context.push(AppPage.clothingAdd.path);
              },
            ),
          )
        ],
      );
    } else {
      return child;
    }
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

enum _ClothesListSlot { header, content }

class _ClothesListLayoutDelegate extends MultiChildLayoutDelegate {
  _ClothesListLayoutDelegate({required this.spacing});

  final double spacing;

  @override
  void performLayout(Size size) {
    final headerSize = layoutChild(
      _ClothesListSlot.header,
      BoxConstraints(maxWidth: size.width),
    );
    final contentHeight =
        math.max(0.0, size.height - headerSize.height - spacing);
    layoutChild(
      _ClothesListSlot.content,
      BoxConstraints(
        minWidth: size.width,
        maxWidth: size.width,
        minHeight: contentHeight,
        maxHeight: contentHeight,
      ),
    );
    positionChild(_ClothesListSlot.header, Offset.zero);
    positionChild(
      _ClothesListSlot.content,
      Offset(0, headerSize.height + spacing),
    );
  }

  @override
  bool shouldRelayout(_ClothesListLayoutDelegate oldDelegate) =>
      oldDelegate.spacing != spacing;
}
