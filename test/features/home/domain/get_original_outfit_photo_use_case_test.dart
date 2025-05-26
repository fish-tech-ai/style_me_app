import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:style_me/core/network/exceptions/server_exception.dart';
import 'package:style_me/core/network/failures/server_failure.dart';
import 'package:style_me/core/network/failures/unknown_failure.dart';
import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/home/data/models/outfit_original_photo_response.dart';
import 'package:style_me/features/home/data/outfit_repository.dart';
import 'package:style_me/features/home/domain/get_original_outfit_photo_use_case.dart';

class MockOutfitRepository extends Mock implements OutfitRepository {}

void main() {
  late MockOutfitRepository mockRepository;
  late NetworkRequestUtil networkUtil;
  late GetOriginalOutfitPhotoUseCase useCase;

  setUp(() {
    mockRepository = MockOutfitRepository();
    networkUtil = NetworkRequestUtil();
    useCase = GetOriginalOutfitPhotoUseCase(mockRepository, networkUtil);
  });

  test('returns Result.success when repository returns data', () async {
    final outfitId = 'outfit123';
    final expectedResponse = OutfitOriginalPhotoResponse("");

    when(() => mockRepository.getOriginalOutfitPhoto(outfitId))
        .thenAnswer((_) async => expectedResponse);

    final result = await useCase(outfitId);

    expect(result, isA<ResultSuccess<OutfitOriginalPhotoResponse>>());
    expect(result.data, expectedResponse);
    expect(result.failure, isNull);
  });

  test('returns Result.fail with ServerFailure on ServerException', () async {
    final outfitId = 'outfit123';

    when(() => mockRepository.getOriginalOutfitPhoto(outfitId))
        .thenThrow(ServerException("Something went wrong", 500));

    final result = await useCase(outfitId);

    expect(result, isA<ResultFail<OutfitOriginalPhotoResponse>>());
    expect(result.data, isNull);
    expect(result.failure, isA<ServerFailure>());
    expect((result.failure as ServerFailure).statusCode, 500);
  });

  test('returns Result.fail with UnknownFailure on unexpected exception', () async {
    final outfitId = 'outfit123';

    when(() => mockRepository.getOriginalOutfitPhoto(outfitId))
        .thenThrow(Exception("Unknown crash"));

    final result = await useCase(outfitId);

    expect(result, isA<ResultFail<OutfitOriginalPhotoResponse>>());
    expect(result.data, isNull);
    expect(result.failure, isA<UnknownFailure>());
  });

  test('calls correct closure in collect()', () async {
    final outfitId = 'outfit123';
    final expectedResponse = OutfitOriginalPhotoResponse("");

    when(() => mockRepository.getOriginalOutfitPhoto(outfitId))
        .thenAnswer((_) async => expectedResponse);

    final result = await useCase(outfitId);

    String collected = '';
    result.collect(
          (data) => collected = 'success',
          (failure) => collected = 'fail',
    );

    expect(collected, 'success');
  });

  test('calls failure closure in collect()', () async {
    final outfitId = 'outfit123';

    when(() => mockRepository.getOriginalOutfitPhoto(outfitId))
        .thenThrow(ServerException("Oops", 404));

    final result = await useCase(outfitId);

    String collected = '';
    result.collect(
          (data) => collected = 'success',
          (failure) => collected = 'fail',
    );

    expect(collected, 'fail');
  });
}
