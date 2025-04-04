import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:style_me/core/extensions/response_ext.dart';
import 'package:style_me/core/network/exceptions/server_exception.dart';

base class MockResponse<T> extends Mock with MockResponseMixin<T> {}

MockResponse getResponse(bool isSuccessful, int statusCode, error, body) {
  final successResponse = MockResponse();
  when(() => successResponse.isSuccessful).thenReturn(isSuccessful);
  when(() => successResponse.statusCode).thenReturn(statusCode);
  when(() => successResponse.error).thenReturn(error);
  when(() => successResponse.body).thenReturn(body);
  return successResponse;
}

MockResponse getSuccessResponse() {
  return getResponse(true, 200, null, "OK");
}

MockResponse getErrorResponse() {
  return getResponse(false, 404, "ERROR", null);
}

MockResponse getEmptyErrorResponse() {
  return getResponse(false, 404, null, null);
}

void main() {
  group('ResponseErrorHandling.handleIfNotSuccessful', () {
    test('does nothing if response is successful', () {
      final response = getSuccessResponse();

      expect(() => response.handleIfNotSuccessful(), returnsNormally);
    });

    test('throws ServerException if response is not successful', () {
      final response = getErrorResponse();

      expect(
        () => response.handleIfNotSuccessful(),
        throwsA(
          isA<ServerException>()
              .having((e) => e.message, 'message', contains('ERROR'))
              .having((e) => e.statusCode, 'statusCode', 404),
        ),
      );
    });

    test('throws ServerException with fallback message if error is empty', () {
      final response = getEmptyErrorResponse();

      expect(
        () => response.handleIfNotSuccessful(),
        throwsA(
          isA<ServerException>()
              .having((e) => e.message, 'message', "null")
              .having((e) => e.statusCode, 'statusCode', 404),
        ),
      );
    });
  });
}
