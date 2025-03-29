import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/utils/validator.dart';
import 'package:style_me/features/settings/domain/change_password_use_case.dart';
import 'package:style_me/features/settings/presentation/state/change_password_state_holder.dart';
import 'package:style_me/features/settings/presentation/ui_models/change_password_args.dart';

part 'change_password_view_model.g.dart';

@riverpod
class ChangePasswordViewModel extends _$ChangePasswordViewModel {
  late final ChangePasswordUseCase _changePasswordUseCase;

  ChangePasswordViewModel() {
    _changePasswordUseCase = getIt();
  }

  @override
  ChangePasswordStateHolder build() {
    return ChangePasswordStateHolder();
  }

  void initFormValidators(AppLocalizations localizations,
      bool isResettingPass) {
    final Validator validator = Validator(localizations);
    state = state.copyWith(
      oldPassword: state.oldPassword.copyWith(
          validate: isResettingPass ? (_) => null : validator.validateIsEmpty,
          isObscured: true,
          focusNode: FocusNode()),
      newPassword: state.newPassword.copyWith(
          validate: validator.validatePassword,
          isObscured: true,
          focusNode: FocusNode()),
      verifyPassword: state.verifyPassword.copyWith(
          validate: (text) =>
              validator.validatePasswordVerify(text, state.newPassword.text),
          isObscured: true,
          focusNode: FocusNode(),
          isLast: true),
    );
  }

  void updateTextInput({
    String? oldPassword,
    String? newPassword,
    String? verifyPassword,
  }) {
    state = state.copyWith(
      oldPassword: state.oldPassword.copyWithTextResettingError(oldPassword),
      newPassword: state.newPassword.copyWithTextResettingError(newPassword),
      verifyPassword:
      state.verifyPassword.copyWithTextResettingError(verifyPassword),
    );
    _silentValidateAll();
  }

  void updateErrorMessage({
    String? oldPasswordError,
    String? newPasswordError,
    String? verifyPasswordError,
  }) {
    state = state.copyWith(
      oldPassword: state.oldPassword.copyWithErrorMessage(oldPasswordError),
      newPassword: state.newPassword.copyWithErrorMessage(newPasswordError),
      verifyPassword:
      state.verifyPassword.copyWithErrorMessage(verifyPasswordError),
    );
  }

  void _silentValidateAll() {
    state = state.copyWith(
      isAllValidated:
      state.oldPassword.validate!(state.oldPassword.text) == null &&
          state.newPassword.validate!(state.newPassword.text) == null &&
          state.verifyPassword.validate!(state.verifyPassword.text) == null,
    );
  }

  void togglePasswordVisibility({
    bool? oldPassword,
    bool? newPassword,
    bool? verifyPassword,
  }) {
    state = state.copyWith(
      oldPassword: state.oldPassword.copyWithIsObscured(oldPassword),
      newPassword: state.newPassword.copyWithIsObscured(newPassword),
      verifyPassword: state.verifyPassword.copyWithIsObscured(verifyPassword),
    );
  }

  Future changePassword(ChangePasswordPageArgs args, Function() onSuccess) async {
    if (state.isAllValidated) {
      await _performPasswordChange(args, onSuccess);
    } else {
      _validateAndShowAll();
    }
  }

  void _validateAndShowAll() {
    state = state.copyWith(
      oldPassword: state.oldPassword.copyWith(
          errorText: state.oldPassword.validate!(state.oldPassword.text)),
      newPassword: state.newPassword.copyWith(
          errorText: state.newPassword.validate!(state.newPassword.text)),
      verifyPassword: state.verifyPassword.copyWith(
          errorText: state.verifyPassword.validate!(state.verifyPassword.text)),
    );
  }

  Future _performPasswordChange(ChangePasswordPageArgs args,
      Function() onSuccess,) async {
    state = state.copyWith(isLoading: true);
    final result = await _changePasswordUseCase(
      args.token,
      state.newPassword.text,
      args.isResettingPass ? null : state.oldPassword.text,
    );
    result.collect((_) {
      onSuccess();
      state = state.copyWith(isLoading: false);
    }, (failure) {
      state = state.copyWith(isLoading: false);
      if (failure.isStatusCodeEquals(HttpStatus.notAcceptable)) {
        state = state.copyWith(
          oldPassword: state.oldPassword
              .copyWith(errorText: localizations.oldPasswordNotCorrect),
        );
        return;
      }
      ref.read(appGlobalViewModelProvider.notifier).showFailure(failure);
    });
  }

  @visibleForTesting
  ChangePasswordViewModel.test(this._changePasswordUseCase);
}
