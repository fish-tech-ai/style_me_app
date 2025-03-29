import 'package:flutter/material.dart';
import 'package:style_me/core/views/input/dropdowns/app_dropdown_button_overlay.dart';
import 'package:style_me/core/views/input/dropdowns/app_dropdown_clickable_view.dart';

class AppDropdownButton<T> extends StatefulWidget {
  final T selectedItem;
  final List<T> items;
  final Widget Function(T item) itemBuilder;
  final Function(T item) onItemSelect;
  final EdgeInsets iconPadding;
  final String? labelText;

  const AppDropdownButton({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.itemBuilder,
    required this.onItemSelect,
    this.iconPadding = const EdgeInsets.all(12),
    this.labelText,
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
    return AppDropdownButtonOverlay.buildOverlay(
      context: context,
      items: widget.items,
      selectedItem: widget.selectedItem,
      layerLink: _layerLink,
      itemBuilder: widget.itemBuilder,
      onTapOutside: _closeDropdown,
      onItemSelect: (item) {
        widget.onItemSelect(item);
        _toggleDropdown();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppDropdownClickableView(
      layerLink: _layerLink,
      onClick: _toggleDropdown,
      selectedItem: widget.selectedItem,
      iconPadding: widget.iconPadding,
      itemBuilder: widget.itemBuilder,
      isDropdownOpen: _isDropdownOpen,
      labelText: widget.labelText,
    );
  }
}
