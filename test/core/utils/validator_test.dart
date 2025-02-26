import 'package:flutter_test/flutter_test.dart';
import 'package:style_me/core/utils/validator.dart';
import 'package:style_me/features/auth/presentation/state/auth_state_holder.dart';
import 'package:style_me/features/auth/presentation/ui_models/auth_page_mode_enum.dart';
import 'package:style_me/features/auth/presentation/ui_models/text_field_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../helpers/shared_test_functions.dart';

class MockAppLocalizations extends AppLocalizations {
  MockAppLocalizations() : super("en");

  @override
  String get textFieldEmpty => 'textFieldEmpty';

  @override
  String get emailInvalid => 'emailInvalid';

  @override
  String get passwordWeakLength => 'passwordWeakLength';

  @override
  String get passwordWeak => 'passwordWeak';

  @override
  String get passwordMismatch => 'passwordMismatch';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late Validator validator;

  setUp(() {
    validator = Validator(initializeAndGetLocalizations());
  });

  group('Validator Tests', () {
    test('validateIsEmpty should return error message if text is empty', () {
      expect(validator.validateIsEmpty(''), 'textFieldEmpty');
      expect(validator.validateIsEmpty('not empty'), null);
    });

    test('validateEmail should return error message if email is invalid', () {
      expect(validator.validateEmail('invalid-email'), 'emailInvalid');
      expect(validator.validateEmail(''), 'textFieldEmpty');
      expect(validator.validateEmail('valid@example.com'), null);
    });

    test('validatePassword should return error message if passwordWeak', () {
      expect(validator.validatePassword('short'), 'passwordWeakLength');
      expect(validator.validatePassword(''), 'textFieldEmpty');
      expect(validator.validatePassword('weakbuthave6chars'), 'passwordWeak');
      expect(validator.validatePassword('StrongPassword123'), null);
    });

    test(
        'validatePasswordVerify should return error message if passwordMismatch',
        () {
      expect(validator.validatePasswordVerify('password1', 'password2'),
          'passwordMismatch');
      expect(
          validator.validatePasswordVerify('', 'password2'), 'textFieldEmpty');
      expect(validator.validatePasswordVerify('password', 'password'), null);
    });

    test(
        'isAllValidated should return true if all fields are valid based on mode',
        () {
      final emailOnlyState = AuthStateHolder(
        mode: AuthPageModeEnum.emailOnly,
        email: TextFieldState(text: 'valid@example.com'),
      );
      expect(validator.isAllValidated(emailOnlyState), true);

      final emailAndPasswordState = AuthStateHolder(
        mode: AuthPageModeEnum.emailAndPassword,
        email: TextFieldState(text: 'valid@example.com'),
        password: TextFieldState(text: 'password'),
      );
      expect(validator.isAllValidated(emailAndPasswordState), true);

      final registrationState = AuthStateHolder(
        mode: AuthPageModeEnum.registration,
        email: TextFieldState(text: 'valid@example.com'),
        password: TextFieldState(text: 'StrongPassword123'),
        passwordVerify: TextFieldState(text: 'StrongPassword123'),
        firstName: TextFieldState(text: 'John'),
        surname: TextFieldState(text: 'Doe'),
      );
      expect(validator.isAllValidated(registrationState), true);

      final confirmationState = AuthStateHolder(
        mode: AuthPageModeEnum.confirmation,
      );
      expect(validator.isAllValidated(confirmationState), true);
    });
  });
}
