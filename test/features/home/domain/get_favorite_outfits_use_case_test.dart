import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:style_me/core/network/exceptions/server_exception.dart';
import 'package:style_me/core/network/failures/server_failure.dart';
import 'package:style_me/core/network/failures/unknown_failure.dart';
import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/home/data/models/outfits_response.dart';
import 'package:style_me/features/home/data/outfit_repository.dart';
import 'package:style_me/features/home/domain/get_favorite_outfits_use_case.dart';

class MockOutfitRepository extends Mock implements OutfitRepository {}

void main() {
  late MockOutfitRepository mockRepository;
  late NetworkRequestUtil networkUtil;
  late GetFavoriteOutfitsUseCase useCase;

  setUp(() {
    mockRepository = MockOutfitRepository();
    networkUtil = NetworkRequestUtil();
    useCase = GetFavoriteOutfitsUseCase(mockRepository, networkUtil);
  });

  test('returns Result.success when repository returns data', () async {
    final expectedResponse = OutfitsResponse([]);

    when(() => mockRepository.getFavoriteOutfits())
        .thenAnswer((_) async => expectedResponse);

    final result = await useCase();

    expect(result is ResultSuccess, true);
    expect(result.data, expectedResponse);
    expect(result.failure, isNull);
  });

  test('returns Result.fail with ServerFailure on ServerException', () async {
    when(() => mockRepository.getFavoriteOutfits()).thenThrow(
      ServerException("Server error", 500),
    );

    final result = await useCase();

    expect(result is ResultSuccess, false);
    expect(result.data, isNull);
    expect(result.failure, isA<ServerFailure>());
    expect((result.failure as ServerFailure).statusCode, 500);
  });

  test('returns Result.fail with UnknownFailure on generic error', () async {
    when(() => mockRepository.getFavoriteOutfits())
        .thenThrow(Exception("Unexpected"));

    final result = await useCase();

    expect(result is ResultSuccess, false);
    expect(result.data, isNull);
    expect(result.failure, isA<UnknownFailure>());
  });
}
