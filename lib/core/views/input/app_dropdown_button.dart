import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';

class AppDropdownButton<T> extends StatefulWidget {
  final T selectedItem;
  final List<T> items;
  final Widget Function(T item) itemBuilder;
  final Function(T item) onItemSelect;
  final EdgeInsets iconPadding;

  const AppDropdownButton({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.itemBuilder,
    required this.onItemSelect,
    this.iconPadding = const EdgeInsets.all(12),
  });

  @override
  State<AppDropdownButton<T>> createState() => _AppDropdownButtonState<T>();
}

class _AppDropdownButtonState<T> extends State<AppDropdownButton<T>> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isDropdownOpen = false;

  void _toggleDropdown() {
    setState(() {
      if (_isDropdownOpen) {
        _closeDropdown();
      } else {
        _openDropdown();
      }
    });
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _isDropdownOpen = true;
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _isDropdownOpen = false;
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final double contextMenuHeight = widget.items.length * 45;
    final double contextMenuMaxHeight = 300;
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
              _closeDropdown();
            },
            child: Container(
              color: Colors.transparent,
            ),
          ),
          Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: showAbove
                  ? Offset(0, -contextMenuHeight - 4)
                  : Offset(0, size.height + 4),
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: contextMenuMaxHeight,
                  ),
                  decoration: BoxDecoration(
                    color: context.theme.dialogBackgroundColor,
                    border: Border.all(
                        color: context.colorScheme.primary, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: widget.items
                        .map(
                          (item) => InkWell(
                            onTap: () {
                              widget.onItemSelect(item);
                              _toggleDropdown();
                            },
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color: item == widget.selectedItem
                                    ? context.colorScheme.secondary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: widget.itemBuilder(item),
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

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: context.colorScheme.primary),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: widget.itemBuilder(widget.selectedItem),
              ),
              Container(
                padding: widget.iconPadding,
                decoration: BoxDecoration(
                    color: context.colorScheme.primary,
                    borderRadius: BorderRadius.circular(11)),
                child: Icon(
                  _isDropdownOpen //TODO dropdown not updated after first time change
                      ? Icons.expand_more_rounded
                      : Icons.expand_less_rounded,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
