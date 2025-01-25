import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:style_me/core/utils/validator.dart';
import 'package:style_me/features/auth/presentation/ui_models/auth_page_mode_enum.dart';
import 'package:style_me/features/auth/presentation/ui_models/text_field_state.dart';

part 'auth_state_holder.freezed.dart';

@freezed
class AuthStateHolder with _$AuthStateHolder {
  const AuthStateHolder._();

  const factory AuthStateHolder({
    /// Text fields state
    @Default(TextFieldState()) TextFieldState firstName,
    @Default(TextFieldState()) TextFieldState surname,
    @Default(TextFieldState()) TextFieldState email,
    @Default(TextFieldState()) TextFieldState password,
    @Default(TextFieldState()) TextFieldState passwordVerify,
    @Default([]) List<FocusNode> focusNodes,

    /// mode
    @Default(AuthPageModeEnum.emailOnly) AuthPageModeEnum mode,
    @Default(AuthPageModeEnum.emailOnly) AuthPageModeEnum previousMode,

    /// validation
    Validator? validator,
    @Default(false) bool isAllValidated,

    /// Toggles
    @Default(false) bool isPasswordVisible,
    @Default(false) bool isPasswordVerifyVisible,

    ///other
    @Default(false) bool isLoading,
    @Default(false) bool showConfirmationPageAsWarning,
  }) = _AuthStateHolder;

  AuthStateHolder copyWithMode(AuthPageModeEnum mode,
      {bool? showConfirmationPageAsWarning}) {
    switch (mode) {
      case AuthPageModeEnum.emailOnly:
        return copyWith(
            mode: mode,
            email: email.copyWith(isVisible: true, isLast: true, position: 0),
            password:
                password.copyWith(isVisible: false, isLast: false, position: 1),
            firstName: firstName.copyWith(isVisible: false, position: 2),
            surname: surname.copyWith(isVisible: false, position: 3),
            passwordVerify: passwordVerify.copyWith(
                isVisible: false, isLast: false, position: 4),
            focusNodes: [
              email.focusNode!,
              password.focusNode!,
              firstName.focusNode!,
              surname.focusNode!,
              passwordVerify.focusNode!,
            ]);
      case AuthPageModeEnum.emailAndPassword:
        return copyWith(
            mode: mode,
            email: email.copyWith(isVisible: true, isLast: false, position: 0),
            password:
                password.copyWith(isVisible: true, isLast: true, position: 1),
            firstName: firstName.copyWith(isVisible: false, position: 2),
            surname: surname.copyWith(isVisible: false, position: 3),
            passwordVerify: passwordVerify.copyWith(
                isVisible: false, isLast: false, position: 4),
            focusNodes: [
              email.focusNode!,
              password.focusNode!,
              firstName.focusNode!,
              surname.focusNode!,
              passwordVerify.focusNode!,
            ]);
      case AuthPageModeEnum.registration:
        return copyWith(
            mode: mode,
            email: email.copyWith(isVisible: true, isLast: false, position: 2),
            password:
                password.copyWith(isVisible: true, isLast: false, position: 3),
            firstName: firstName.copyWith(isVisible: true, position: 0),
            surname: surname.copyWith(isVisible: true, position: 1),
            passwordVerify: passwordVerify.copyWith(
                isVisible: true, isLast: true, position: 4),
            focusNodes: [
              firstName.focusNode!,
              surname.focusNode!,
              email.focusNode!,
              password.focusNode!,
              passwordVerify.focusNode!,
            ]);
      case AuthPageModeEnum.confirmation:
        return copyWith(
          mode: mode,
          showConfirmationPageAsWarning: showConfirmationPageAsWarning ?? false,
          email: email.copyWith(isVisible: true, isLast: true, position: 0),
        );
    }
  }
}
