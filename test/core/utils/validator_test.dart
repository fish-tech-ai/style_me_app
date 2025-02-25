
import 'package:flutter_test/flutter_test.dart';
import 'package:style_me/core/utils/validator.dart';
import 'package:style_me/features/auth/presentation/state/auth_state_holder.dart';
import 'package:style_me/features/auth/presentation/ui_models/auth_page_mode_enum.dart';
import 'package:style_me/features/auth/presentation/ui_models/text_field_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MockAppLocalizations extends AppLocalizations {
  MockAppLocalizations() : super("en");

  @override
  String get textFieldEmpty => 'Field cannot be empty';

  @override
  String get emailInvalid => 'Invalid email';

  @override
  String get passwordWeakLength => 'Password must be longer than 6 characters';

  @override
  String get passwordWeak => 'Password is weak';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late Validator validator;
  late MockAppLocalizations localizations;

  setUp(() {
    localizations = MockAppLocalizations();
    validator = Validator(localizations);
  });

  group('Validator Tests', () {
    test('validateIsEmpty should return error message if text is empty', () {
      expect(validator.validateIsEmpty(''), 'Field cannot be empty');
      expect(validator.validateIsEmpty('not empty'), null);
    });

    test('validateEmail should return error message if email is invalid', () {
      expect(validator.validateEmail('invalid-email'), 'Invalid email');
      expect(validator.validateEmail(''), 'Field cannot be empty');
      expect(validator.validateEmail('valid@example.com'), null);
    });

    test('validatePassword should return error message if password is weak', () {
      expect(validator.validatePassword('short'), 'Password must be longer than 6 characters');
      expect(validator.validatePassword(''), 'Field cannot be empty');
      expect(validator.validatePassword('weakbuthave6chars'), 'Password is weak');
      expect(validator.validatePassword('StrongPassword123'), null);
    });

    test('validatePasswordVerify should return error message if passwords do not match', () {
      expect(validator.validatePasswordVerify('password1', 'password2'), 'Passwords do not match');
      expect(validator.validatePasswordVerify('', 'password2'), 'Field cannot be empty');
      expect(validator.validatePasswordVerify('password', 'password'), null);
    });

    test('isAllValidated should return true if all fields are valid based on mode', () {
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