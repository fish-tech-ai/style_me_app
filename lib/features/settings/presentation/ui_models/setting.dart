import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';

part 'setting.freezed.dart';

/// [actionText] - If not provided, [Icons.keyboard_arrow_right_rounded] will be presented instead.
///
/// [forceForegroundColor] - this option will force [label] and [actionText] (or icon if actionText is null) to be [forceForegroundColor].
///
/// [path] - If not null will automatically push to this path, otherwise [onItemClicked] will be called.
///
/// [onItemClicked] - will be called if path is null, for more complex handling [GoRouter] can be provided
/// **NOTE**: If [onItemClicked] and [path] are both null, then a [SettingsItem] will not be clickable,

@freezed
class Setting with _$Setting {
  const factory Setting({
    required String label,
    String? subLabel,
    String? actionText,
    Function(GoRouter?)? onItemClicked,
    Color Function(BuildContext context)? forceForegroundColor,
    String? path,
  }) = _Setting;
}
