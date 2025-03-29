import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';

class AppToggleButtons<T> extends StatelessWidget {
  final T? selectedItem;
  final List<T> allItems;
  final Widget Function(T item) itemContentBuilder;
  final Function(T item) onSelectedItemChanged;

  const AppToggleButtons({
    super.key,
    required this.selectedItem,
    required this.itemContentBuilder,
    required this.onSelectedItemChanged,
    required this.allItems,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...allItems.mapIndexed((index, item) {
          return buildToggleButton(context, index, item);
        })
      ],
    );
  }

  Widget buildToggleButton(BuildContext context, int index, T item) {
    final isSelected = selectedItem == item;
    final radius = Radius.circular(12);
    final shape = index == 0
        ? BorderRadius.only(topLeft: radius, bottomLeft: radius)
        : index == allItems.length - 1
            ? BorderRadius.only(topRight: radius, bottomRight: radius)
            : BorderRadius.zero;
    final backgroundColor = isSelected
        ? context.colorScheme.primary
        : context.colorScheme.primaryContainer;
    final foregroundColor = isSelected
        ? context.colorScheme.onPrimary
        : context.colorScheme.primary;
    final borderColor =
        isSelected ? context.colorScheme.primary : foregroundColor;
    return Expanded(
      child: InkWell(
        borderRadius: shape,
        onTap: () => onSelectedItemChanged(item),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: shape,
              border: Border.all(color: borderColor)),
          child: DefaultTextStyle(
            style: TextStyle(color: foregroundColor),
            child: itemContentBuilder(item),
          ),
        ),
      ),
    );
  }
}
