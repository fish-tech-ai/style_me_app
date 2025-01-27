import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/core/network/failures/login_failure.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/core/utils/validator.dart';
import 'package:style_me/features/auth/data/models/email_state_enum.dart';
import 'package:style_me/features/auth/domain/check_email_use_case.dart';
import 'package:style_me/features/auth/domain/confirm_email_use_case.dart';
import 'package:style_me/features/auth/domain/login_use_case.dart';
import 'package:style_me/features/auth/domain/register_use_case.dart';
import 'package:style_me/features/auth/presentation/state/auth_state_holder.dart';
import 'package:style_me/features/auth/presentation/ui_models/auth_page_mode_enum.dart';
import 'package:style_me/features/auth/presentation/ui_models/text_field_state.dart';

part 'auth_view_model.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late final CheckEmailUseCase _checkEmailUseCase;
  late final ConfirmEmailUseCase _confirmEmailUseCase;
  late final LoginUseCase _loginUseCase;
  late final RegisterUseCase _registerUseCase;

  AuthViewModel() {
    _checkEmailUseCase = getIt();
    _confirmEmailUseCase = getIt();
    _loginUseCase = getIt();
    _registerUseCase = getIt();
  }

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
      firstName: state.firstName.copyWithTextResettingError(firstName),
      surname: state.surname.copyWithTextResettingError(surname),
      email: state.email.copyWithTextResettingError(email),
      password: state.password.copyWithTextResettingError(password),
      passwordVerify:
          state.passwordVerify.copyWithTextResettingError(passwordVerify),
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
      firstName: state.firstName.copyWithErrorMessage(firstNameError),
      surname: state.surname.copyWithErrorMessage(surnameError),
      email: state.email.copyWithErrorMessage(emailError),
      password: state.password.copyWithErrorMessage(passwordError),
      passwordVerify:
          state.passwordVerify.copyWithErrorMessage(passwordVerifyError),
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

  void onContinueButtonClicked(
      AppLocalizations localizations, Function goToHome) async {
    switch (state.mode) {
      case AuthPageModeEnum.emailOnly:
        checkEmail();
        break;
      case AuthPageModeEnum.emailAndPassword:
        loginUser(localizations, goToHome);
        break;
      case AuthPageModeEnum.registration:
        registerUser();
        break;
      case AuthPageModeEnum.confirmation:

        /// Continue button is not visible in this mode
        break;
    }
  }

  void onCheckEmailSuccess(EmailStateEnum result) {
    switch (result) {
      case EmailStateEnum.registeredAndConfirmed:
        changePageMode(AuthPageModeEnum.emailAndPassword);
        break;
      case EmailStateEnum.notConfirmed:
        changePageMode(AuthPageModeEnum.confirmation,
            showConfirmationPageAsWarning: true);
        break;
      case EmailStateEnum.notFound:
        changePageMode(AuthPageModeEnum.registration);
        break;
    }
    state = state.copyWith(isLoading: false);
  }

  void changePageMode(AuthPageModeEnum mode,
      {bool? showConfirmationPageAsWarning}) {
    state = state.copyWith(previousMode: state.mode);
    state = state.copyWithMode(
      mode,
      showConfirmationPageAsWarning: showConfirmationPageAsWarning,
    );
    _clearTextFieldsExceptEmail();
    _clearValidationErrors();
    _silentValidateAll();
    state.focusNodes.first.requestFocus();
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

  void checkEmail() async {
    state = state.copyWith(isLoading: true);
    final result = await _checkEmailUseCase(state.email.text);
    result.collect((result) {
      onCheckEmailSuccess(result);
    }, (failure) {
      ref.read(appGlobalViewModelProvider.notifier).showFailure(failure);
      state = state.copyWith(isLoading: false);
    });
  }

  void registerUser() async {
    state = state.copyWith(isLoading: true);
    final Result result = await _registerUseCase(state);
    result.collect((result) {
      changePageMode(AuthPageModeEnum.confirmation);
      state = state.copyWith(isLoading: false);
    }, (failure) {
      ref.read(appGlobalViewModelProvider.notifier).showFailure(failure);
      state = state.copyWith(isLoading: false);
    });
  }

  void loginUser(AppLocalizations localizations, Function goToHome) async {
    state = state.copyWith(isLoading: true);
    final Result result = await _loginUseCase(state);
    result.collect((result) {
      goToHome();
      state = state.copyWith(isLoading: false);
    }, (failure) {
      ref
          .read(appGlobalViewModelProvider.notifier)
          .showFailure(LoginFailure.from(failure, localizations.loginFailed));
      state = state.copyWith(isLoading: false);
    });
  }

  void ensureEmailVisible() {
    if (state.mode == AuthPageModeEnum.emailOnly &&
        state.previousMode == AuthPageModeEnum.confirmation) {
      state = state.copyWith(
          email: state.email.copyWith(isVisible: true),
          previousMode: AuthPageModeEnum.emailOnly);
    }
  }
}
