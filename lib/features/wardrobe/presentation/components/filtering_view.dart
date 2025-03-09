import 'package:flutter/material.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/views/animators/animated_visibility.dart';
import 'package:style_me/core/views/buttons/app_button.dart';
import 'package:style_me/core/views/buttons/app_outlined_button.dart';
import 'package:style_me/core/views/buttons/app_toggle_buttons.dart';
import 'package:style_me/core/views/input/app_dropdown_button.dart';
import 'package:style_me/core/views/ui_models/app_button_icon.dart';
import 'package:style_me/core/views/ui_models/icon_position.dart';
import 'package:style_me/features/auth/presentation/ui_models/anim_direction_enum.dart';
import 'package:style_me/features/wardrobe/data/models/clothing_category_enum.dart';
import 'package:style_me/features/wardrobe/data/models/clothing_position_enum.dart';

class FilteringView extends StatefulWidget {
  final ClothingPositionEnum? selectedPosition;
  final ClothingCategoryEnum selectedCategory;
  final Function() onFiltersClose;
  final Function(ClothingPositionEnum?, ClothingCategoryEnum) onFiltersChange;

  const FilteringView({
    super.key,
    required this.onFiltersClose,
    required this.onFiltersChange,
    required this.selectedPosition,
    required this.selectedCategory,
  });

  @override
  State<FilteringView> createState() => _FilteringViewState();
}

class _FilteringViewState extends State<FilteringView> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6,
      children: [
        buildFiltersButton(),
        buildExpandableView(),
      ],
    );
  }

  Widget buildFiltersButton() {
    return IntrinsicWidth(
      child: isExpanded
          ? AppOutlinedButton(
              text: localizations.clearFilters,
              trailingIcon: Icon(Icons.filter_list_off_rounded),
              height: 40,
              onClick: () {
                toggleFilters();
              },
            )
          : AppButton(
              text: localizations.filters,
              height: 40,
              onClick: () {
                toggleFilters();
              },
              icon: AppButtonIcon(
                Icons.filter_list_rounded,
                IconPosition.trailing,
              ),
            ),
    );
  }

  void toggleFilters() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  Widget buildExpandableView() {
    return AnimatedVisibility(
      isVisible: isExpanded,
      animateAtFirstBuild: false,
      animDirection: AnimDirectionEnum.bottomToTop,
      reversed: true,
      child: Column(
        spacing: 6,
        children: [
          buildPositionToggleButtons(),
          buildCategoryDropdown(),
        ],
      ),
    );
  }

  Widget buildPositionToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 6,
      children: [
        Text(
          "${localizations.position}:",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: AppToggleButtons(
            selectedItem: widget.selectedPosition,
            allItems: ClothingPositionEnum.values,
            itemContentBuilder: (item) => Text(item.text),
            onSelectedItemChanged: (item) {
              widget.onFiltersChange(
                  widget.selectedPosition == item ? null : item,
                  widget.selectedCategory);
            },
          ),
        )
      ],
    );
  }

  Widget buildCategoryDropdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 6,
      children: [
        Text("${localizations.category}:"),
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: 160),
          child: AppDropdownButton(
              items: ClothingCategoryEnum.values,
              iconPadding: EdgeInsets.all(10),
              selectedItem: widget.selectedCategory,
              itemBuilder: (item) =>
                  Text(item.text),
              onItemSelect: (item) {
                widget.onFiltersChange(widget.selectedPosition, item);
              }),
        )
      ],
    );
  }
}
