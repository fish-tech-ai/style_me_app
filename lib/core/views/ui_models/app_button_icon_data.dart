import 'package:flutter/material.dart';
import 'package:style_me/core/views/ui_models/icon_position.dart';

class AppButtonIconData {
  final IconData? icon;
  final String? svgAsset;
  final bool isFromAsset;
  final IconPosition position;

  const AppButtonIconData._(
      this.icon, this.svgAsset, this.isFromAsset, this.position);

  factory AppButtonIconData.iconData(IconData icon, IconPosition position) {
    return AppButtonIconData._(icon, null, false, position);
  }

  factory AppButtonIconData.svg(String asset, IconPosition position) {
    return AppButtonIconData._(null, asset, true, position);
  }

  factory AppButtonIconData.empty() {
    return AppButtonIconData._(
        Icons.do_not_disturb_alt_rounded, null, false, IconPosition.leading);
  }
}
