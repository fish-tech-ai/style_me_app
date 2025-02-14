import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'text_field_state.freezed.dart';

@freezed
class TextFieldState with _$TextFieldState {
  const TextFieldState._();

  const factory TextFieldState({
    @Default("") String text,
    @Default(false) bool isVisible,
    String? errorText,
    String? Function(String)? validate,
    @Default(false) bool isLast,
    FocusNode? focusNode,
    @Default(0) int position,
    @Default(false) bool isObscured,
  }) = _TextFieldState;

  TextFieldState copyWithTextResettingError(String? text) {
    return copyWith(
        text: text ?? this.text, errorText: text != null ? null : errorText);
  }

  TextFieldState copyWithErrorMessage(String? errorText) {
    return copyWith(errorText: errorText ?? this.errorText);
  }

  TextFieldState copyWithIsObscured(bool? isObscured) {
    return copyWith(isObscured: isObscured ?? this.isObscured);
  }
}
