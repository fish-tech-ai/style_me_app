import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/core/extensions/global_ext.dart';
import 'package:style_me/core/extensions/widget_ref_ext.dart';
import 'package:style_me/core/network/failures/login_failure.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/core/utils/google_auth_service.dart';
import 'package:style_me/core/utils/validator.dart';
import 'package:style_me/features/auth/data/models/email_state_enum.dart';
import 'package:style_me/features/auth/domain/check_email_use_case.dart';
import 'package:style_me/features/auth/domain/login_use_case.dart';
import 'package:style_me/features/auth/domain/login_with_google_use_case.dart';
import 'package:style_me/features/auth/domain/register_use_case.dart';
import 'package:style_me/features/auth/domain/resend_confirmation_use_case.dart';
import 'package:style_me/features/auth/domain/send_reset_password_mail_use_case.dart';
import 'package:style_me/features/auth/presentation/state/auth_state_holder.dart';
import 'package:style_me/features/auth/presentation/ui_models/auth_page_mode_enum.dart';
import 'package:style_me/features/auth/presentation/ui_models/text_field_state.dart';

part 'auth_view_model.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late final CheckEmailUseCase _checkEmailUseCase;
  late final ResendConfirmationUseCase _resendConfirmationUseCase;
  late final LoginUseCase _loginUseCase;
  late final LoginWithGoogleUseCase _loginWithGoogleUseCase;
  late final RegisterUseCase _registerUseCase;
  late final SendResetPasswordMailUseCase _sendResetPasswordMailUseCase;
  late final GoogleAuthService _googleAuthService;

  AuthViewModel() {
    _checkEmailUseCase = getIt();
    _resendConfirmationUseCase = getIt();
    _loginUseCase = getIt();
    _loginWithGoogleUseCase = getIt();
    _registerUseCase = getIt();
    _googleAuthService = getIt();
    _sendResetPasswordMailUseCase = getIt();
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
          validate: (text) =>
              validator.validatePasswordWithMode(text, state.mode),
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

  Future onContinueButtonClicked(
      AppLocalizations localizations, Function goToHome) async {
    switch (state.mode) {
      case AuthPageModeEnum.emailOnly:
        checkEmail(localizations);
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

  void onCheckEmailSuccess(
      EmailStateEnum result, AppLocalizations localizations) {
    switch (result) {
      case EmailStateEnum.registeredAndConfirmed:
        changePageMode(AuthPageModeEnum.emailAndPassword);
        break;
      case EmailStateEnum.notConfirmed:
        changePageMode(AuthPageModeEnum.confirmation,
            showConfirmationPageAsWarning: true,
            showConfirmationPageForPasswordReset: false);
        break;
      case EmailStateEnum.notFound:
        changePageMode(AuthPageModeEnum.registration);
        break;
      case EmailStateEnum.loggedWithGoogle:
        ref
            .read(appGlobalViewModelProvider.notifier)
            .showErrorMessage(localizations.usuallyOtherLoginMethod);
        break;
    }
    state = state.copyWith(isLoading: false);
  }

  void changePageMode(AuthPageModeEnum mode,
      {bool? showConfirmationPageAsWarning,
      bool? showConfirmationPageForPasswordReset}) {
    state = state.copyWith(previousMode: state.mode);
    state = state.copyWithMode(mode,
        showConfirmationPageAsWarning: showConfirmationPageAsWarning,
        showConfirmationPageForPasswordReset:
            showConfirmationPageForPasswordReset);
    _clearTextFieldsExceptEmail();
    _clearValidationErrors();
    _silentValidateAll();
    if (state.mode == AuthPageModeEnum.emailAndPassword) {
      state.focusNodes[1].requestFocus();
    } else if (state.mode == AuthPageModeEnum.emailOnly ||
        state.mode == AuthPageModeEnum.registration) {
      state.focusNodes.first.requestFocus();
    }
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
              ?.validatePasswordWithMode(state.password.text, state.mode)),
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

  Future checkEmail(AppLocalizations localizations) async {
    state = state.copyWith(isLoading: true);
    final result = await _checkEmailUseCase(state.email.text);
    result.collect((result) {
      onCheckEmailSuccess(result, localizations);
    }, (failure) {
      ref.read(appGlobalViewModelProvider.notifier).showFailure(failure);
      state = state.copyWith(isLoading: false);
    });
  }

  Future registerUser() async {
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

  Future loginUser(AppLocalizations localizations, Function goToHome) async {
    state = state.copyWith(isLoading: true);
    final Result result = await _loginUseCase(state);
    result.collect((result) {
      goToHome();
      state = state.copyWith(isLoading: false);
      ref.globalViewModel.initUser();
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

  Future resendEmail() async {
    Result result;
    result = state.showConfirmationPageForPasswordReset
        ? await _sendResetPasswordMailUseCase(state.email.text)
        : await _resendConfirmationUseCase(state.email.text);
    result.collect(
      (_) {},
      (failure) {
        ref.read(appGlobalViewModelProvider.notifier).showFailure(failure);
      },
    );
  }

  Future sendResetPasswordMail(String emailNotFoundMessage) async {
    final validationResult = state.validator?.validateEmail(state.email.text);
    if (validationResult != null) {
      state = state.copyWith(
        email: state.email.copyWith(errorText: validationResult),
        password: state.password.copyWith(errorText: null),
      );
      return;
    }
    _performSendResetPasswordMail(emailNotFoundMessage);
  }

  Future signInWithGoogle(Function() goToHome) async {
    final idToken = await _googleAuthService.signInWithGoogle();
    if (idToken != null) {
      debugMessagePrint(idToken);
      final result = await _loginWithGoogleUseCase(idToken);
      result.collect((_) {
        goToHome();
      }, (failure) {
        _googleAuthService.signOut();
        ref.read(appGlobalViewModelProvider.notifier).showFailure(failure);
      });
    }
  }

  void _performSendResetPasswordMail(String emailNotFoundMessage) async {
    state = state.copyWith(isLoading: true);
    final result = await _sendResetPasswordMailUseCase(state.email.text);
    result.collect(
      (_) {
        state = state.copyWith(isLoading: false);
        state = state.copyWithMode(AuthPageModeEnum.confirmation,
            showConfirmationPageAsWarning: false,
            showConfirmationPageForPasswordReset: true);
      },
      (failure) {
        state = state.copyWith(isLoading: false);
        if (failure.message?.startsWith("404") ?? false) {
          state = state.copyWith(
              email: state.email.copyWith(errorText: emailNotFoundMessage));
        }
        ref.read(appGlobalViewModelProvider.notifier).showFailure(failure);
      },
    );
  }

  @visibleForTesting
  AuthViewModel.test(
    this._checkEmailUseCase,
    this._resendConfirmationUseCase,
    this._loginUseCase,
    this._loginWithGoogleUseCase,
    this._registerUseCase,
    this._sendResetPasswordMailUseCase,
    this._googleAuthService,
  );
}
