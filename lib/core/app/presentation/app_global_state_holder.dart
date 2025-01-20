import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:style_me/core/network/failures/failure.dart';

part 'app_global_state_holder.freezed.dart';

@freezed
class AppGlobalStateHolder with _$AppGlobalStateHolder {
  const factory AppGlobalStateHolder({
    Brightness? currentTheme,
    @Default(true) bool isConnected,
    Failure? failure,
  }) = _AppStateHolder;
}
