import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:style_me/core/utils/validator.dart';
import 'package:style_me/features/auth/presentation/state/auth_state_holder.dart';
import 'package:style_me/features/auth/presentation/ui_models/auth_page_mode_enum.dart';
import 'package:style_me/features/auth/presentation/ui_models/text_field_state.dart';

part 'auth_view_model.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  @override
  AuthStateHolder build() {
    return AuthStateHolder(
        focusNodes: List.generate(5, (index) => FocusNode()));
  }

  void initFormValidators(AppLocalizations localizations) {
    final validator = Validator(localizations);
    state = state.copyWith(
      firstName: TextFieldState(
          validate: validator.validateIsEmpty, focusNode: FocusNode()),
      surname: TextFieldState(
          validate: validator.validateIsEmpty, focusNode: FocusNode()),
      email: TextFieldState(
          validate: validator.validateEmail,
          isVisible: true,
          isLast: true,
          focusNode: FocusNode()),
      password: TextFieldState(
          validate: (text) => validator.validatePassword(text, state.mode),
          focusNode: FocusNode()),
      passwordVerify: TextFieldState(
          validate: (text) =>
              validator.validatePasswordVerify(text, state.password.text),
          focusNode: FocusNode()),
      validator: validator,
    );
    state = state.copyWith(focusNodes: [
      state.email.focusNode!,
      state.password.focusNode!,
      state.firstName.focusNode!,
      state.surname.focusNode!,
      state.passwordVerify.focusNode!,
    ]);
  }

  void updateTextInput({
    String? firstName,
    String? surname,
    String? email,
    String? password,
    String? passwordVerify,
  }) {
    state = state.copyWith(
      firstName: state.firstName.copyWith(
          text: firstName ?? state.firstName.text,
          errorText: firstName != null ? null : state.firstName.errorText),
      surname: state.surname.copyWith(
          text: surname ?? state.surname.text,
          errorText: surname != null ? null : state.surname.errorText),
      email: state.email.copyWith(
          text: email ?? state.email.text,
          errorText: email != null ? null : state.email.errorText),
      password: state.password.copyWith(
          text: password ?? state.password.text,
          errorText: password != null ? null : state.password.errorText),
      passwordVerify: state.passwordVerify.copyWith(
          text: passwordVerify ?? state.passwordVerify.text,
          errorText:
              passwordVerify != null ? null : state.passwordVerify.errorText),
    );
    _silentValidateAll();
  }

  void updateErrorMessage({
    String? firstNameError,
    String? surnameError,
    String? emailError,
    String? passwordError,
    String? passwordVerifyError,
  }) {
    state = state.copyWith(
      firstName: state.firstName
          .copyWith(errorText: firstNameError ?? state.firstName.errorText),
      surname: state.surname
          .copyWith(errorText: surnameError ?? state.surname.errorText),
      email:
          state.email.copyWith(errorText: emailError ?? state.email.errorText),
      password: state.password
          .copyWith(errorText: passwordError ?? state.password.errorText),
      passwordVerify: state.passwordVerify.copyWith(
          errorText: passwordVerifyError ?? state.passwordVerify.errorText),
    );
  }

  void updateTextFieldVisibility({
    bool? firstNameVisibility,
    bool? surnameVisibility,
    bool? emailVisibility,
    bool? passwordVisibility,
    bool? passwordVerifyVisibility,
  }) {
    state = state.copyWith(
      firstName: state.firstName.copyWith(
          isVisible: firstNameVisibility ?? state.firstName.isVisible),
      surname: state.surname
          .copyWith(isVisible: surnameVisibility ?? state.surname.isVisible),
      email: state.email
          .copyWith(isVisible: emailVisibility ?? state.email.isVisible),
      password: state.password
          .copyWith(isVisible: passwordVisibility ?? state.password.isVisible),
      passwordVerify: state.passwordVerify.copyWith(
          isVisible:
              passwordVerifyVisibility ?? state.passwordVerify.isVisible),
    );
  }

  void _silentValidateAll() {
    state =
        state.copyWith(isAllValidated: state.validator!.isAllValidated(state));
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void togglePasswordVerifyVisibility() {
    state =
        state.copyWith(isPasswordVerifyVisible: !state.isPasswordVerifyVisible);
  }

  void onContinueButtonClicked() {
    switch (state.mode) {
      case AuthPageModeEnum.emailOnly:
        changePageMode(AuthPageModeEnum.emailAndPassword);
        break;
      case AuthPageModeEnum.emailAndPassword:
        changePageMode(AuthPageModeEnum.registration);
        break;
      case AuthPageModeEnum.registration:
        changePageMode(AuthPageModeEnum.emailOnly);
        break;
    }
    changePageMode(state.mode);
    _silentValidateAll();
  }

  void changePageMode(AuthPageModeEnum mode) {
    state = state.copyWithMode(mode);
    _clearTextFieldsExceptEmail();
    _clearValidationErrors();
    _silentValidateAll();
  }

  void validateAndShowAll() {
    state = state.copyWith(
      firstName: state.firstName.copyWith(
          errorText: state.validator?.validateIsEmpty(state.firstName.text)),
      surname: state.surname.copyWith(
          errorText: state.validator?.validateIsEmpty(state.surname.text)),
      email: state.email.copyWith(
          errorText: state.validator?.validateEmail(state.email.text)),
      password: state.password.copyWith(
          errorText: state.validator
              ?.validatePassword(state.password.text, state.mode)),
      passwordVerify: state.passwordVerify.copyWith(
          errorText: state.validator?.validatePasswordVerify(
              state.passwordVerify.text, state.password.text)),
    );
  }

  void _clearValidationErrors() {
    state = state.copyWith(
      firstName: state.firstName.copyWith(errorText: null),
      surname: state.surname.copyWith(errorText: null),
      email: state.email.copyWith(errorText: null),
      password: state.password.copyWith(errorText: null),
      passwordVerify: state.passwordVerify.copyWith(errorText: null),
    );
  }

  void _clearTextFieldsExceptEmail() {
    state = state.copyWith(
      firstName: state.firstName.copyWith(text: ""),
      surname: state.surname.copyWith(text: ""),
      password: state.password.copyWith(text: ""),
      passwordVerify: state.passwordVerify.copyWith(text: ""),
    );
  }
}
