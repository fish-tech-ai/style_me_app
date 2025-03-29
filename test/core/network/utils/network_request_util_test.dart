import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:style_me/core/network/exceptions/server_exception.dart';
import 'package:style_me/core/network/failures/failure.dart';
import 'package:style_me/core/network/failures/server_failure.dart';
import 'package:style_me/core/network/failures/unknown_failure.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/core/network/utils/network_request_util.dart';

class MockRequest extends Mock {
  Future<int> call();
}

class MockOnSuccess extends Mock {
  Future<void> call(int result);
}

class MockOnError extends Mock {
  Future<void> call(Failure failure);
}

class FakeFailure extends Fake implements Failure {}

void main() {
  late NetworkRequestUtil networkRequestUtil;
  late MockRequest mockRequest;
  late MockOnSuccess mockOnSuccess;
  late MockOnError mockOnError;

  setUpAll(() {
    registerFallbackValue(FakeFailure());
  });

  setUp(() {
    networkRequestUtil = NetworkRequestUtil();
    mockRequest = MockRequest();
    mockOnSuccess = MockOnSuccess();
    mockOnError = MockOnError();
  });

  test('returns Result.success when request is successful', () async {
    const expectedResponse = 42;

    when(() => mockRequest()).thenAnswer((_) async => expectedResponse);
    when(() => mockOnSuccess(any())).thenAnswer((_) async => Future.value());

    final result = await networkRequestUtil.makeRepositoryRequest<int>(
      mockRequest.call,
      onSuccess: mockOnSuccess.call,
    );

    expect(result, isA<ResultSuccess<int>>());
    expect(result.data, expectedResponse);
    verify(() => mockRequest()).called(1);
    verify(() => mockOnSuccess(expectedResponse)).called(1);
    verifyNever(() => mockOnError(any()));
  });

  test('returns Result.fail with ServerFailure when ServerException occurs',
      () async {
    const errorMessage = 'Server Error';
    const statusCode = 500;

    when(() => mockRequest())
        .thenThrow(ServerException(errorMessage, statusCode));
    when(() => mockOnError(any())).thenAnswer((_) async => Future.value());

    final result = await networkRequestUtil.makeRepositoryRequest<int>(
      mockRequest.call,
      onError: mockOnError.call,
    );

    expect(result, isA<ResultFail<int>>());
    expect(result.failure, isA<ServerFailure>());
    expect(result.failure?.message, errorMessage);
    expect((result.failure as ServerFailure).statusCode, statusCode);
    verify(() => mockRequest()).called(1);
    verify(() => mockOnError(result.failure!)).called(1);
    verifyNever(() => mockOnSuccess(any()));
  });

  test('returns Result.fail with UnknownFailure for other exceptions',
      () async {
    when(() => mockRequest()).thenThrow(Exception('Unknown Error'));
    when(() => mockOnError(any())).thenAnswer((_) async => Future.value());

    final result = await networkRequestUtil.makeRepositoryRequest<int>(
      mockRequest.call,
      onError: mockOnError.call,
    );

    expect(result, isA<ResultFail<int>>());
    expect(result.failure, isA<UnknownFailure>());
    verify(() => mockRequest()).called(1);
    verify(() => mockOnError(any())).called(1);
    verifyNever(() => mockOnSuccess(any()));
  });

  test('calls onSuccess when provided and request is successful', () async {
    const expectedResponse = 100;

    when(() => mockRequest()).thenAnswer((_) async => expectedResponse);
    when(() => mockOnSuccess(any())).thenAnswer((_) async => Future.value());

    await networkRequestUtil.makeRepositoryRequest<int>(
      mockRequest.call,
      onSuccess: mockOnSuccess.call,
    );

    verify(() => mockOnSuccess(expectedResponse)).called(1);
    verifyNever(() => mockOnError(any()));
  });

  test('calls onError with ServerFailure when ServerException occurs',
      () async {
    const errorMessage = 'Server Failure';
    const statusCode = 404;

    when(() => mockRequest())
        .thenThrow(ServerException(errorMessage, statusCode));
    when(() => mockOnError(any())).thenAnswer((_) async => Future.value());

    await networkRequestUtil.makeRepositoryRequest<int>(
      mockRequest.call,
      onError: mockOnError.call,
    );

    verify(() => mockOnError(any(that: isA<ServerFailure>()))).called(1);
    verifyNever(() => mockOnSuccess(any()));
  });

  test('calls onError with UnknownFailure for unknown exceptions', () async {
    when(() => mockRequest()).thenThrow(Exception('Unexpected Error'));
    when(() => mockOnError(any())).thenAnswer((_) async => Future.value());

    await networkRequestUtil.makeRepositoryRequest<int>(
      mockRequest.call,
      onError: mockOnError.call,
    );

    verify(() => mockOnError(any(that: isA<UnknownFailure>()))).called(1);
    verifyNever(() => mockOnSuccess(any()));
  });
}
