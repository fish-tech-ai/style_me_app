import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:style_me/core/network/exceptions/server_exception.dart';
import 'package:style_me/core/network/failures/server_failure.dart';
import 'package:style_me/core/network/failures/unknown_failure.dart';
import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/home/data/outfit_repository.dart';
import 'package:style_me/features/home/domain/set_is_outfit_favorite_use_case.dart';

class MockOutfitRepository extends Mock implements OutfitRepository {}

void main() {
  late MockOutfitRepository mockRepository;
  late NetworkRequestUtil networkUtil;
  late SetIsOutfitFavoriteUseCase useCase;

  setUp(() {
    mockRepository = MockOutfitRepository();
    networkUtil = NetworkRequestUtil();
    useCase = SetIsOutfitFavoriteUseCase(mockRepository, networkUtil);
  });

  const outfitId = 'test-id';
  const shouldLike = true;

  test('returns Result.success<void> when repository completes without error', () async {
    when(() => mockRepository.setIsOutfitFavorite(outfitId, shouldLike))
        .thenAnswer((_) async {});

    final result = await useCase(outfitId, shouldLike);

    expect(result, isA<ResultSuccess<void>>());
    expect(result.data, isNull); // since it's void
    expect(result.failure, isNull);
  });

  test('returns Result.fail with ServerFailure on ServerException', () async {
    when(() => mockRepository.setIsOutfitFavorite(outfitId, shouldLike))
        .thenThrow(ServerException("Failure", 400));

    final result = await useCase(outfitId, shouldLike);

    expect(result, isA<ResultFail<void>>());
    expect(result.failure, isA<ServerFailure>());
    expect((result.failure as ServerFailure).statusCode, 400);
    expect(result.data, isNull);
  });

  test('returns Result.fail with UnknownFailure on generic error', () async {
    when(() => mockRepository.setIsOutfitFavorite(outfitId, shouldLike))
        .thenThrow(Exception("Unexpected"));

    final result = await useCase(outfitId, shouldLike);

    expect(result, isA<ResultFail<void>>());
    expect(result.failure, isA<UnknownFailure>());
    expect(result.data, isNull);
  });

  test('calls correct closure in collect on success', () async {
    when(() => mockRepository.setIsOutfitFavorite(outfitId, shouldLike))
        .thenAnswer((_) async {});

    final result = await useCase(outfitId, shouldLike);

    String state = '';
    result.collect(
          (_) => state = 'success',
          (_) => state = 'fail',
    );

    expect(state, 'success');
  });

  test('calls correct closure in collect on failure', () async {
    when(() => mockRepository.setIsOutfitFavorite(outfitId, shouldLike))
        .thenThrow(ServerException("fail", 500));

    final result = await useCase(outfitId, shouldLike);

    String state = '';
    result.collect(
          (_) => state = 'success',
          (_) => state = 'fail',
    );

    expect(state, 'fail');
  });
}
