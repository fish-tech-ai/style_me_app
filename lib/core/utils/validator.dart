import 'package:style_me/core/utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:style_me/features/auth/presentation/state/auth_state_holder.dart';
import 'package:style_me/features/auth/presentation/ui_models/auth_page_mode_enum.dart';

class Validator {
  final AppLocalizations localizations;

  Validator(this.localizations);

  /// Entire modes validations
  bool isAllValidated(AuthStateHolder state) {
    switch (state.mode) {
      case AuthPageModeEnum.emailOnly:
        return _validateEmailOnly(state);
      case AuthPageModeEnum.emailAndPassword:
        return _validateEmailAndPassword(state);
      case AuthPageModeEnum.registration:
        return _validateRegistration(state);
    }
  }

  bool _validateEmailOnly(AuthStateHolder state) {
    return state.email.text.isNotEmpty &&
        RegExp(RegexConst.emailRegex).hasMatch(state.email.text);
  }

  bool _validateEmailAndPassword(AuthStateHolder state) {
    return _validateEmailOnly(state) && state.password.text.isNotEmpty;
  }

  bool _validateRegistration(AuthStateHolder state) {
    return _validateEmailOnly(state) &&
        validatePassword(state.password.text, state.mode) == null &&
        state.password.text == state.passwordVerify.text &&
        state.firstName.text.isNotEmpty &&
        state.surname.text.isNotEmpty;
  }

  /// Single text fields validations
  String? validateIsEmpty(String text) {
    return text.isEmpty ? localizations.textFieldEmpty : null;
  }

  String? validateEmail(String text) {
    if (!RegExp(RegexConst.emailRegex).hasMatch(text)) {
      return localizations.emailInvalid;
    } else if (text.isEmpty) {
      return localizations.textFieldEmpty;
    }
    return null;
  }

  String? validatePassword(String text, AuthPageModeEnum mode) {
    if (mode != AuthPageModeEnum.registration) {
      return validateIsEmpty(text);
    }

    if (text.length <= 6) {
      return localizations.passwordWeakLength;
    } else if (!RegExp(RegexConst.passwordRegex).hasMatch(text)) {
      return localizations.passwordWeak;
    } else if (text.isEmpty) {
      return localizations.textFieldEmpty;
    }
    return null;
  }

  String? validatePasswordVerify(String text, String password) {
    if (text != password) {
      return localizations.passwordMismatch;
    } else if (text.isEmpty) {
      return localizations.textFieldEmpty;
    }
    return null;
  }
}
