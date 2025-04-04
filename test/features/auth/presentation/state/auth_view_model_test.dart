import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/network/failures/server_failure.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/core/utils/google_auth_service.dart';
import 'package:style_me/features/auth/data/models/email_state_enum.dart';
import 'package:style_me/features/auth/domain/check_email_use_case.dart';
import 'package:style_me/features/auth/domain/login_use_case.dart';
import 'package:style_me/features/auth/domain/login_with_google_use_case.dart';
import 'package:style_me/features/auth/domain/register_use_case.dart';
import 'package:style_me/features/auth/domain/resend_confirmation_use_case.dart';
import 'package:style_me/features/auth/domain/send_reset_password_mail_use_case.dart';
import 'package:style_me/features/auth/presentation/state/auth_view_model.dart';
import 'package:style_me/features/auth/presentation/ui_models/auth_page_mode_enum.dart';

import '../../../../helpers/shared_test_functions.dart';
import 'auth_view_model_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<CheckEmailUseCase>(),
  MockSpec<ResendConfirmationUseCase>(),
  MockSpec<LoginUseCase>(),
  MockSpec<LoginWithGoogleUseCase>(),
  MockSpec<RegisterUseCase>(),
  MockSpec<SendResetPasswordMailUseCase>(),
  MockSpec<GoogleAuthService>(),
])
void main() {
  late MockCheckEmailUseCase mockCheckEmailUseCase;
  late MockResendConfirmationUseCase mockResendConfirmationUseCase;
  late MockLoginUseCase mockLoginUseCase;
  late MockLoginWithGoogleUseCase mockLoginWithGoogleUseCase;
  late MockRegisterUseCase mockRegisterUseCase;
  late MockSendResetPasswordMailUseCase mockSendResetPasswordMailUseCase;
  late MockGoogleAuthService mockGoogleAuthService;
  late MockitoAppGlobalViewModel mockAppGlobalViewModel;
  late ProviderContainer container;
  late AuthViewModel authViewModel;

  setUp(() {
    initializeAndGetLocalizations();
    mockCheckEmailUseCase = MockCheckEmailUseCase();
    mockResendConfirmationUseCase = MockResendConfirmationUseCase();
    mockLoginUseCase = MockLoginUseCase();
    mockLoginWithGoogleUseCase = MockLoginWithGoogleUseCase();
    mockRegisterUseCase = MockRegisterUseCase();
    mockSendResetPasswordMailUseCase = MockSendResetPasswordMailUseCase();
    mockGoogleAuthService = MockGoogleAuthService();
    mockAppGlobalViewModel = MockitoAppGlobalViewModel();

    container = ProviderContainer(overrides: [
      authViewModelProvider.overrideWith(
        () => AuthViewModel.test(
            mockCheckEmailUseCase,
            mockResendConfirmationUseCase,
            mockLoginUseCase,
            mockLoginWithGoogleUseCase,
            mockRegisterUseCase,
            mockSendResetPasswordMailUseCase,
            mockGoogleAuthService),
      ),
      appGlobalViewModelProvider.overrideWith(() => mockAppGlobalViewModel),
    ]);

    authViewModel = container.read(authViewModelProvider.notifier);
    authViewModel.initFormValidators(localizations);
    provideDummy(Result.fail(ServerFailure("", 404)));
  });

  tearDown(() {
    container.dispose();
  });

  test('initFormValidators initializes form validators', () {
    expect(authViewModel.state.firstName.validate, isNotNull);
    expect(authViewModel.state.surname.validate, isNotNull);
    expect(authViewModel.state.email.validate, isNotNull);
    expect(authViewModel.state.password.validate, isNotNull);
    expect(authViewModel.state.passwordVerify.validate, isNotNull);
  });

  test('updateTextInput updates text input and validates', () {
    authViewModel.updateTextInput(
      firstName: 'John',
      surname: 'Doe',
      email: 'john.doe@example.com',
      password: 'password123',
      passwordVerify: 'password123',
    );

    expect(authViewModel.state.firstName.text, 'John');
    expect(authViewModel.state.surname.text, 'Doe');
    expect(authViewModel.state.email.text, 'john.doe@example.com');
    expect(authViewModel.state.password.text, 'password123');
    expect(authViewModel.state.passwordVerify.text, 'password123');
    expect(authViewModel.state.isAllValidated, true);
  });

  test('updateErrorMessage updates error messages', () {
    authViewModel.updateErrorMessage(
      firstNameError: 'First name error',
      surnameError: 'Surname error',
      emailError: 'Email error',
      passwordError: 'Password error',
      passwordVerifyError: 'Password verify error',
    );

    expect(authViewModel.state.firstName.errorText, 'First name error');
    expect(authViewModel.state.surname.errorText, 'Surname error');
    expect(authViewModel.state.email.errorText, 'Email error');
    expect(authViewModel.state.password.errorText, 'Password error');
    expect(
        authViewModel.state.passwordVerify.errorText, 'Password verify error');
  });

  test('togglePasswordVisibility toggles visibility', () {
    authViewModel.togglePasswordVisibility();

    expect(authViewModel.state.isPasswordVisible, true);

    authViewModel.togglePasswordVisibility();

    expect(authViewModel.state.isPasswordVisible, false);
  });

  test('onContinueButtonClicked calls checkEmail in emailOnly mode', () async {
    authViewModel.changePageMode(AuthPageModeEnum.emailOnly);
    provideDummy(Result.success(EmailStateEnum.registeredAndConfirmed));

    await authViewModel.onContinueButtonClicked(localizations, () {});

    verify(mockCheckEmailUseCase.call(any)).called(1);
  });

  test('onContinueButtonClicked calls loginUser in emailAndPassword mode',
      () async {
    authViewModel.changePageMode(AuthPageModeEnum.emailAndPassword);

    await authViewModel.onContinueButtonClicked(localizations, () {});

    verify(mockLoginUseCase.call(any)).called(1);
  });

  test('onContinueButtonClicked calls registerUser in registration mode',
      () async {
    authViewModel.changePageMode(AuthPageModeEnum.registration);

    await authViewModel.onContinueButtonClicked(localizations, () {});

    verify(mockRegisterUseCase.call(any)).called(1);
  });

  test('checkEmail success', () async {
    when(mockCheckEmailUseCase.call(any)).thenAnswer(
        (_) async => Result.success(EmailStateEnum.registeredAndConfirmed));

    await authViewModel.checkEmail(localizations);

    expect(authViewModel.state.isLoading, false);
    expect(authViewModel.state.mode, AuthPageModeEnum.emailAndPassword);
  });

  test('checkEmail failure', () async {
    final failure = ServerFailure("message", 404);
    provideDummy(Result.success(EmailStateEnum.notConfirmed));
    when(mockCheckEmailUseCase.call(""))
        .thenAnswer((_) async => Result.fail(failure));

    await authViewModel.checkEmail(localizations);

    verify(mockAppGlobalViewModel.showFailure(failure)).called(1);
    expect(authViewModel.state.isLoading, false);
  });

  test('registerUser success', () async {
    when(mockRegisterUseCase.call(any))
        .thenAnswer((_) async => Result.success(null));

    await authViewModel.registerUser();

    expect(authViewModel.state.isLoading, false);
    expect(authViewModel.state.mode, AuthPageModeEnum.confirmation);
  });

  test('registerUser failure', () async {
    final failure = ServerFailure("message", 404);
    when(mockRegisterUseCase.call(any))
        .thenAnswer((_) async => Result.fail(failure));

    await authViewModel.registerUser();

    verify(mockAppGlobalViewModel.showFailure(failure)).called(1);
    expect(authViewModel.state.isLoading, false);
  });

  test('loginUser success', () async {
    when(mockLoginUseCase.call(any))
        .thenAnswer((_) async => Result.success(null));

    bool goToHomeCalled = false;
    await authViewModel.loginUser(localizations, () {
      goToHomeCalled = true;
    });

    expect(goToHomeCalled, true);
    expect(authViewModel.state.isLoading, false);
  });

  test('loginUser failure', () async {
    final failure = ServerFailure(HttpStatus.unauthorized.toString(), 401);

    when(mockLoginUseCase.call(any))
        .thenAnswer((_) async => Result.fail(failure));

    await authViewModel.loginUser(localizations, () {});

    expect(authViewModel.state.isLoading, false);
  });

  test('signInWithGoogle success', () async {
    when(mockGoogleAuthService.signInWithGoogle())
        .thenAnswer((_) async => 'idToken');
    when(mockLoginWithGoogleUseCase.call(any))
        .thenAnswer((_) async => Result.success(null));

    bool goToHomeCalled = false;
    await authViewModel.signInWithGoogle(() {
      goToHomeCalled = true;
    });

    expect(goToHomeCalled, true);
  });

  test('signInWithGoogle failure', () async {
    final failure = ServerFailure("", 404);
    when(mockGoogleAuthService.signInWithGoogle())
        .thenAnswer((_) async => 'idToken');
    when(mockLoginWithGoogleUseCase.call(any))
        .thenAnswer((_) async => Result.fail(failure));

    await authViewModel.signInWithGoogle(() {});

    verify(mockGoogleAuthService.signOut()).called(1);
    verify(mockAppGlobalViewModel.showFailure(failure)).called(1);
  });

  test('sendResetPasswordMail validation failed', () async {
    when(mockSendResetPasswordMailUseCase.call(any))
        .thenAnswer((_) async => Result.success(null));

    await authViewModel.sendResetPasswordMail('Email not found');

    expect(authViewModel.state.isLoading, false);
    expect(authViewModel.state.mode, AuthPageModeEnum.emailOnly);
    expect(authViewModel.state.email.errorText, isNotNull);
    expect(authViewModel.state.password.errorText, isNull);
  });

  test('sendResetPasswordMail success', () async {
    when(mockSendResetPasswordMailUseCase.call(any))
        .thenAnswer((_) async => Result.success(null));
    authViewModel.state = authViewModel.state.copyWith(validator: null);

    await authViewModel.sendResetPasswordMail('Email not found');

    expect(authViewModel.state.isLoading, false);
    expect(authViewModel.state.mode, AuthPageModeEnum.confirmation);
  });

  test('sendResetPasswordMail failure', () async {
    final failure = ServerFailure("", 403);
    when(mockSendResetPasswordMailUseCase.call(any))
        .thenAnswer((_) async => Result.fail(failure));
    authViewModel.state = authViewModel.state.copyWith(validator: null);

    await authViewModel.sendResetPasswordMail('Email not found');

    verify(mockAppGlobalViewModel.showFailure(failure)).called(1);
    expect(authViewModel.state.isLoading, false);
  });
}
