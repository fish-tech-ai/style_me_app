import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:style_me/core/local/database.dart';
import 'package:style_me/core/network/exceptions/server_exception.dart';
import 'package:style_me/core/network/services/auth_service.dart';
import 'package:style_me/features/auth/data/auth_repository.dart';
import 'package:style_me/features/auth/data/models/email_state_enum.dart';
import 'package:style_me/features/auth/data/models/login_request.dart';
import 'package:style_me/features/auth/data/models/login_response.dart';
import 'package:style_me/features/auth/data/models/refresh_token_request.dart';
import 'package:style_me/features/auth/data/models/refresh_token_response.dart';

base class MockResponse<T> extends Mock with MockResponseMixin<T> {}

class MockAuthService extends Mock implements AuthService {}

class MockAppDatabase extends Mock implements AppDatabase {}

void main() {
  late MockAuthService service;
  late MockAppDatabase db;
  late AuthRepository repo;

  setUp(() {
    service = MockAuthService();
    db = MockAppDatabase();
    repo = AuthRepository(service, db);
    registerFallbackValue(UserCompanion.insert(
        name: "name",
        email: "email",
        token: "token",
        refreshToken: "refreshToken",
        isFromGoogleSignIn: false));
    registerFallbackValue(LoginRequest(email: "", password: ""));
    registerFallbackValue(RefreshTokenRequest(""));
    registerFallbackValue(RefreshTokenResponse("", ""));
  });

  group('AuthRepository', () {
    test('checkEmail returns correct EmailStateEnum', () async {
      final mockResponse = MockResponse();
      when(() => mockResponse.statusCode).thenReturn(200);
      when(() => service.checkEmail('test@example.com'))
          .thenAnswer((_) async => mockResponse);

      final result = await repo.checkEmail('test@example.com');
      expect(result, EmailStateEnum.registeredAndConfirmed);
    });

    test('checkEmail throws ServerException on unknown code', () async {
      final mockResponse = MockResponse();
      when(() => mockResponse.statusCode).thenReturn(999);
      when(() => mockResponse.error).thenReturn('Unknown');
      when(() => service.checkEmail(any()))
          .thenAnswer((_) async => mockResponse);

      expect(() => repo.checkEmail('unknown@mail.com'),
          throwsA(isA<ServerException>()));
    });

    test('login succeeds and saves user', () async {
      final loginRequest = LoginRequest(email: 'test', password: '123');
      final loginResponse = LoginResponse("", "", "", "", false);

      final mockResponse = MockResponse<LoginResponse>();
      when(() => mockResponse.statusCode).thenReturn(200);
      when(() => mockResponse.isSuccessful).thenReturn(true);
      when(() => mockResponse.body).thenReturn(loginResponse);
      when(() => service.login(loginRequest))
          .thenAnswer((_) async => mockResponse);
      when(() => db.setUser(any())).thenAnswer((_) async => null);

      final result = await repo.login(loginRequest);
      expect(result, loginResponse);
      verify(() => db.setUser(any())).called(1);
    });

    test('login throws on unauthorized', () async {
      final loginRequest = LoginRequest(email: 'test', password: '123');
      final mockResponse = MockResponse<LoginResponse>();
      when(() => mockResponse.statusCode).thenReturn(401);
      when(() => service.login(any())).thenAnswer((_) async => mockResponse);

      expect(() => repo.login(loginRequest), throwsA(isA<ServerException>()));
    });

    test('loginWithGoogle succeeds and saves user', () async {
      final loginResponse = LoginResponse("", "", "", "", false);

      final mockResponse = MockResponse<LoginResponse>();
      when(() => mockResponse.statusCode).thenReturn(200);
      when(() => mockResponse.isSuccessful).thenReturn(true);
      when(() => mockResponse.body).thenReturn(loginResponse);
      when(() => service.loginWithGoogle(any()))
          .thenAnswer((_) async => mockResponse);
      when(() => db.setUser(any())).thenAnswer((_) async => null);

      final result = await repo.loginWithGoogle('token123');
      expect(result, loginResponse);
      verify(() => db.setUser(any())).called(1);
    });

    test('refreshToken succeeds and updates user', () async {
      final response = RefreshTokenResponse('newToken', 'newRefresh');
      final mockResponse = MockResponse<RefreshTokenResponse>();
      when(() => mockResponse.statusCode).thenReturn(200);
      when(() => mockResponse.isSuccessful).thenReturn(true);
      when(() => mockResponse.body).thenReturn(response);

      when(() => service.refreshToken(any()))
          .thenAnswer((_) async => mockResponse);
      when(() => db.updateUser(any())).thenAnswer((_) async {});

      final result = await repo.refreshToken('oldToken');
      expect(result, response);
      verify(() => db.updateUser(response)).called(1);
    });
  });
}
