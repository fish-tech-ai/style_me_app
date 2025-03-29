import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:style_me/core/app/domain/usecases/get_user_use_case.dart';
import 'package:style_me/core/app/domain/usecases/logout_user_use_case.dart';
import 'package:style_me/core/app/domain/usecases/refresh_token_use_case.dart';
import 'package:style_me/core/local/database.dart';
import 'package:style_me/core/network/failures/failure.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/core/utils/google_auth_service.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/core/utils/token_authenticator.dart';

class MockGetUserUseCase extends Mock implements GetUserUseCase {}

class MockRefreshTokenUseCase extends Mock implements RefreshTokenUseCase {}

class MockLogoutUserUseCase extends Mock implements LogoutUserUseCase {}

class MockGoogleAuthService extends Mock implements GoogleAuthService {}

class TestFailure extends Failure {
  TestFailure() : super("Test Failure");
}

void main() {
  late TokenAuthenticator authenticator;
  late MockGetUserUseCase getUserUseCase;
  late MockRefreshTokenUseCase refreshTokenUseCase;
  late MockLogoutUserUseCase logoutUserUseCase;
  late MockGoogleAuthService googleAuthService;

  void registerMocks() {
    getUserUseCase = MockGetUserUseCase();
    refreshTokenUseCase = MockRefreshTokenUseCase();
    logoutUserUseCase = MockLogoutUserUseCase();
    googleAuthService = MockGoogleAuthService();

    getIt.registerSingleton<GetUserUseCase>(getUserUseCase);
    getIt.registerSingleton<RefreshTokenUseCase>(refreshTokenUseCase);
    getIt.registerSingleton<LogoutUserUseCase>(logoutUserUseCase);
    getIt.registerSingleton<GoogleAuthService>(googleAuthService);
  }

  final user = UserData(
    id: 1,
    email: "test@mail.com",
    name: "Test",
    token: "valid-token",
    refreshToken: "valid-refresh-token",
    isFromGoogleSignIn: false,
  );

  setUp(() {
    getIt.reset();
    registerMocks();

    authenticator = TokenAuthenticator();
  });

  test('authenticateUser returns true if token is valid', () async {
    const validJwt = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
        'eyJleHAiOjI0NzIzNDMyMDB9.'
        'signature';
    final validUser = user.copyWith(token: validJwt, refreshToken: validJwt);
    when(() => getUserUseCase())
        .thenAnswer((_) async => Result.success(validUser));

    final result = await authenticator.authenticateUser();
    expect(result, isTrue);
  });

  test('authenticateUser refreshes token if expired and refresh succeeds',
      () async {
    const validJwt =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjI0NzIzNDMyMDB9.signature';
    const expiredJwt =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjI0NzIzNDMyfQ.signature';
    final expiredUser =
        user.copyWith(token: expiredJwt, refreshToken: validJwt);
    when(() => getUserUseCase())
        .thenAnswer((_) async => Result.success(expiredUser));
    when(() => refreshTokenUseCase.call(any()))
        .thenAnswer((_) async => Result.success(null));

    final result = await authenticator.authenticateUser();
    expect(result, isTrue);
  });

  test('authenticateUser fails if refresh token expired', () async {
    const expiredJwt =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjI0NzIzNDMyfQ.signature';
    final expiredUser =
        user.copyWith(token: expiredJwt, refreshToken: expiredJwt);
    when(() => getUserUseCase())
        .thenAnswer((_) async => Result.success(expiredUser));
    when(() => logoutUserUseCase()).thenAnswer((_) async => null);
    when(() => googleAuthService.signOut()).thenAnswer((_) async {});

    final result = await authenticator.authenticateUser();
    expect(result, isFalse);

    verify(() => logoutUserUseCase()).called(1);
    verify(() => googleAuthService.signOut()).called(1);
  });

  test('authenticateUser returns false on failure', () async {
    when(() => getUserUseCase())
        .thenAnswer((_) async => Result.fail(TestFailure()));
    final result = await authenticator.authenticateUser();
    expect(result, isFalse);
  });

  test('_performTokenRefresh returns true on success', () async {
    const validJwt =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjI0NzIzNDMyMDB9.signature';
    final expiredUser = user.copyWith(token: validJwt, refreshToken: validJwt);
    when(() => getUserUseCase())
        .thenAnswer((_) async => Result.success(expiredUser));
    when(() => refreshTokenUseCase.call(any()))
        .thenAnswer((_) async => Result.success(null));

    final result = await authenticator.refreshAndGetNewToken();
    expect(result, isNull);
  });

  test('_performTokenRefresh calls logout on failure', () async {
    const validJwt =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjI0NzIzNDMyMDB9.signature';
    const expiredJwt =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjI0NzIzNDMyfQ.signature';
    final expiredUser =
        user.copyWith(token: expiredJwt, refreshToken: validJwt);
    when(() => getUserUseCase())
        .thenAnswer((_) async => Result.success(expiredUser));
    when(() => refreshTokenUseCase.call(any()))
        .thenAnswer((_) async => Result.fail(TestFailure()));
    when(() => logoutUserUseCase()).thenAnswer((_) async => null);
    when(() => googleAuthService.signOut()).thenAnswer((_) async {});

    final result = await authenticator.refreshAndGetNewToken();
    expect(result, isNull);

    verify(() => logoutUserUseCase()).called(1);
    verify(() => googleAuthService.signOut()).called(1);
  });
}
