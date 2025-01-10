import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'text_field_state.freezed.dart';

@freezed
class TextFieldState with _$TextFieldState {
  const factory TextFieldState({
    @Default("") String text,
    @Default(false) bool isVisible,
    String? errorText,
    String? Function(String)? validate,
    @Default(false) bool isLast,
    FocusNode? focusNode,
    @Default(0) int position,
  }) = _TextFieldState;
}
