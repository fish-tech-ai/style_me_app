import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/network/failures/server_failure.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/settings/domain/change_password_use_case.dart';
import 'package:style_me/features/settings/presentation/state/view_models/change_password_view_model.dart';
import 'package:style_me/features/settings/presentation/ui_models/change_password_args.dart';

import '../../../../../helpers/shared_test_functions.dart';
import 'change_password_view_model_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ChangePasswordUseCase>()])
void main() {
  late MockChangePasswordUseCase mockChangePasswordUseCase;
  late MockitoAppGlobalViewModel mockAppGlobalViewModel;
  late ProviderContainer container;
  late ChangePasswordViewModel changePasswordViewModel;

  setUp(() {
    initializeAndGetLocalizations();
    mockChangePasswordUseCase = MockChangePasswordUseCase();
    mockAppGlobalViewModel = MockitoAppGlobalViewModel();

    container = ProviderContainer(overrides: [
      changePasswordViewModelProvider.overrideWith(
          () => ChangePasswordViewModel.test(mockChangePasswordUseCase)),
      appGlobalViewModelProvider.overrideWith(() => mockAppGlobalViewModel),
    ]);

    changePasswordViewModel =
        container.read(changePasswordViewModelProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  test('initFormValidators initializes form validators', () {
    changePasswordViewModel.initFormValidators(localizations, false);

    expect(changePasswordViewModel.state.oldPassword.validate, isNotNull);
    expect(changePasswordViewModel.state.newPassword.validate, isNotNull);
    expect(changePasswordViewModel.state.verifyPassword.validate, isNotNull);
  });

  test('updateTextInput updates text input and validates', () {
    changePasswordViewModel.initFormValidators(localizations, false);
    changePasswordViewModel.updateTextInput(
      oldPassword: 'Test1234567',
      newPassword: 'Test1234',
      verifyPassword: 'Test1234',
    );

    expect(changePasswordViewModel.state.oldPassword.text, 'Test1234567');
    expect(changePasswordViewModel.state.newPassword.text, 'Test1234');
    expect(changePasswordViewModel.state.verifyPassword.text, 'Test1234');
    expect(changePasswordViewModel.state.isAllValidated, true);
  });

  test('updateErrorMessage updates error messages', () {
    changePasswordViewModel.updateErrorMessage(
      oldPasswordError: 'Old password error',
      newPasswordError: 'New password error',
      verifyPasswordError: 'Verify password error',
    );

    expect(changePasswordViewModel.state.oldPassword.errorText,
        'Old password error');
    expect(changePasswordViewModel.state.newPassword.errorText,
        'New password error');
    expect(changePasswordViewModel.state.verifyPassword.errorText,
        'Verify password error');
  });

  test('togglePasswordVisibility toggles visibility', () {
    changePasswordViewModel.togglePasswordVisibility(
      oldPassword: false,
      newPassword: false,
      verifyPassword: false,
    );

    expect(changePasswordViewModel.state.oldPassword.isObscured, false);
    expect(changePasswordViewModel.state.newPassword.isObscured, false);
    expect(changePasswordViewModel.state.verifyPassword.isObscured, false);
  });

  test('changePassword success', () async {
    final args = ChangePasswordPageArgs('token', false);
    provideDummy(Result.fail(ServerFailure("", 404)));
    changePasswordViewModel.initFormValidators(localizations, false);
    changePasswordViewModel.updateTextInput(
      oldPassword: 'Test123456',
      newPassword: 'Test1234',
      verifyPassword: 'Test1234',
    );

    await changePasswordViewModel.changePassword(args, () {});

    verify(mockChangePasswordUseCase.call('token', 'Test1234', 'Test123456'))
        .called(1);
    expect(changePasswordViewModel.state.isLoading, false);
    expect(changePasswordViewModel.state.oldPassword.errorText, isNull);
    expect(changePasswordViewModel.state.newPassword.errorText, isNull);
    expect(changePasswordViewModel.state.verifyPassword.errorText, isNull);
  });

  test('changePassword failure', () async {
    final args = ChangePasswordPageArgs('token', false);
    provideDummy(Result.fail(ServerFailure("", 404)));
    when(mockChangePasswordUseCase.call(any, any, any)).thenAnswer(
        (_) async => Result.fail(ServerFailure("", HttpStatus.notAcceptable)));
    changePasswordViewModel.initFormValidators(localizations, false);
    changePasswordViewModel.updateTextInput(
      oldPassword: 'Test123456',
      newPassword: 'Test1234',
      verifyPassword: 'Test1234',
    );

    await changePasswordViewModel.changePassword(args, () {});

    verify(mockChangePasswordUseCase.call(
            'token', 'Test1234', 'Test123456'))
        .called(1);
    expect(changePasswordViewModel.state.oldPassword.errorText, isNotNull);
    expect(changePasswordViewModel.state.isLoading, false);
  });
}
