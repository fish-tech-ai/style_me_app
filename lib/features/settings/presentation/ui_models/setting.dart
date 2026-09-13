import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:style_me/features/settings/presentation/ui_models/setting_action.dart';

part 'setting.freezed.dart';

/// [actionText] - If not provided, [Icons.keyboard_arrow_right_rounded] will be presented instead.
///
/// [forceForegroundColor] - this option will force [label] and [actionText] (or icon if actionText is null) to be [forceForegroundColor].
///
/// [action] - runs action if path is null
@freezed
sealed class Setting with _$Setting {
  const factory Setting({
    required String label,
    String? subLabel,
    String? actionText,
    SettingAction? action,
    Color Function(BuildContext context)? forceForegroundColor,
    String? path,
  }) = _Setting;
}
