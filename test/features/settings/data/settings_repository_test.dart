import 'package:mocktail/mocktail.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:style_me/core/network/exceptions/server_exception.dart';
import 'package:style_me/core/network/services/app_service.dart';
import 'package:style_me/core/network/services/user_service.dart';
import 'package:style_me/features/auth/data/models/reset_password_request.dart';
import 'package:style_me/features/settings/data/models/delete_user_request.dart';
import 'package:style_me/features/settings/data/models/report_category.dart';
import 'package:style_me/features/settings/data/models/report_request.dart';
import 'package:style_me/features/settings/data/settings_repository.dart';

class MockUserService extends Mock implements UserService {}

class MockAppService extends Mock implements AppService {}

base class MockResponse extends Mock with MockResponseMixin {}

void main() {
  late MockUserService userService;
  late MockAppService appService;
  late SettingsRepository repo;

  setUp(() {
    userService = MockUserService();
    appService = MockAppService();
    repo = SettingsRepository(userService, appService);
    registerFallbackValue(ResetPasswordRequest("", ""));
    registerFallbackValue(DeleteUserRequest(""));
    registerFallbackValue(ReportRequest("", ReportCategory.APP_SETTINGS));
  });

  group('SettingsRepository', () {
    test('resetPassword succeeds on 200', () async {
      final mockResponse = MockResponse();
      when(() => mockResponse.statusCode).thenReturn(200);
      when(() => mockResponse.isSuccessful).thenReturn(true);
      when(() => userService.resetPassword(any(), any()))
          .thenAnswer((_) async => mockResponse);

      await repo.resetPassword(
          ResetPasswordRequest("pass", "newPass"), 'abc123');
      verify(() => userService.resetPassword(any(), any())).called(1);
    });

    test('resetPassword throws ServerException on 406', () async {
      final mockResponse = MockResponse();
      when(() => mockResponse.statusCode).thenReturn(406);
      when(() => userService.resetPassword(any(), any()))
          .thenAnswer((_) async => mockResponse);

      expect(
        () => repo.resetPassword(
            ResetPasswordRequest("pass", "newPass"), 'abc123'),
        throwsA(isA<ServerException>()),
      );
    });

    test('deleteAccount succeeds on 200', () async {
      final mockResponse = MockResponse();
      when(() => mockResponse.statusCode).thenReturn(200);
      when(() => mockResponse.isSuccessful).thenReturn(true);
      when(() => userService.deleteAccount(any()))
          .thenAnswer((_) async => mockResponse);

      await repo.deleteAccount(DeleteUserRequest('pass123'));
      verify(() => userService.deleteAccount(any())).called(1);
    });

    test('deleteAccount throws ServerException on 403', () async {
      final mockResponse = MockResponse();
      when(() => mockResponse.statusCode).thenReturn(403);

      when(() => userService.deleteAccount(any()))
          .thenAnswer((_) async => mockResponse);

      expect(
        () => repo.deleteAccount(DeleteUserRequest('pass123')),
        throwsA(isA<ServerException>()),
      );
    });

    test('addReport calls handleIfNotSuccessful', () async {
      final mockResponse = MockResponse();
      when(() => mockResponse.statusCode).thenReturn(200);
      when(() => mockResponse.isSuccessful).thenReturn(true);
      when(() => appService.addReport(any()))
          .thenAnswer((_) async => mockResponse);

      await repo.addReport(ReportRequest("", ReportCategory.APP_SETTINGS));
      verify(() => appService.addReport(any())).called(1);
    });
  });
}
