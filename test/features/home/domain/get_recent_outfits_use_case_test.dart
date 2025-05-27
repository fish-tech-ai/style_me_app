import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:style_me/core/network/exceptions/server_exception.dart';
import 'package:style_me/core/network/failures/server_failure.dart';
import 'package:style_me/core/network/failures/unknown_failure.dart';
import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/home/data/models/outfits_response.dart';
import 'package:style_me/features/home/data/outfit_repository.dart';
import 'package:style_me/features/home/domain/get_recent_outfits_use_case.dart';

class MockOutfitRepository extends Mock implements OutfitRepository {}

void main() {
  late MockOutfitRepository mockRepository;
  late NetworkRequestUtil networkUtil;
  late GetRecentOutfitsUseCase useCase;

  setUp(() {
    mockRepository = MockOutfitRepository();
    networkUtil = NetworkRequestUtil();
    useCase = GetRecentOutfitsUseCase(mockRepository, networkUtil);
  });

  test('returns Result.success with OutfitsResponse on success', () async {
    final response = OutfitsResponse([]);

    when(() => mockRepository.getRecentOutfits())
        .thenAnswer((_) async => response);

    final result = await useCase();

    expect(result, isA<ResultSuccess<OutfitsResponse>>());
    expect(result.data, response);
    expect(result.failure, isNull);
  });

  test('returns Result.fail with ServerFailure on ServerException', () async {
    when(() => mockRepository.getRecentOutfits())
        .thenThrow(ServerException("Server error", 500));

    final result = await useCase();

    expect(result, isA<ResultFail<OutfitsResponse>>());
    expect(result.data, isNull);
    expect(result.failure, isA<ServerFailure>());
    expect((result.failure as ServerFailure).statusCode, 500);
  });

  test('returns Result.fail with UnknownFailure on generic exception', () async {
    when(() => mockRepository.getRecentOutfits())
        .thenThrow(Exception("Unexpected"));

    final result = await useCase();

    expect(result, isA<ResultFail<OutfitsResponse>>());
    expect(result.data, isNull);
    expect(result.failure, isA<UnknownFailure>());
  });

  test('calls correct closure in collect() on success', () async {
    final response = OutfitsResponse([]);
    when(() => mockRepository.getRecentOutfits())
        .thenAnswer((_) async => response);

    final result = await useCase();

    String state = '';
    result.collect(
          (data) => state = 'success',
          (failure) => state = 'fail',
    );

    expect(state, 'success');
  });

  test('calls correct closure in collect() on failure', () async {
    when(() => mockRepository.getRecentOutfits())
        .thenThrow(ServerException("Down", 503));

    final result = await useCase();

    String state = '';
    result.collect(
          (data) => state = 'success',
          (failure) => state = 'fail',
    );

    expect(state, 'fail');
  });
}
