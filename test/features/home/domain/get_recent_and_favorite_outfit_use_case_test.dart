import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:style_me/core/network/exceptions/server_exception.dart';
import 'package:style_me/core/network/failures/server_failure.dart';
import 'package:style_me/core/network/failures/unknown_failure.dart';
import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/home/data/models/outfits_response.dart';
import 'package:style_me/features/home/data/models/recent_and_favorite_outfit_response.dart';
import 'package:style_me/features/home/data/outfit_repository.dart';
import 'package:style_me/features/home/domain/get_recent_and_favorite_outfit_use_case.dart';

class MockOutfitRepository extends Mock implements OutfitRepository {}

void main() {
  late MockOutfitRepository mockRepository;
  late NetworkRequestUtil networkUtil;
  late GetRecentAndFavoriteOutfitUseCase useCase;

  setUp(() {
    mockRepository = MockOutfitRepository();
    networkUtil = NetworkRequestUtil();
    useCase = GetRecentAndFavoriteOutfitUseCase(mockRepository, networkUtil);
  });

  test('returns Result.success with RecentAndFavoriteOutfitResponse on success', () async {
    final favorites = OutfitsResponse([]);
    final recent = OutfitsResponse([]);

    when(() => mockRepository.getFavoriteOutfits())
        .thenAnswer((_) async => favorites);
    when(() => mockRepository.getRecentOutfits())
        .thenAnswer((_) async => recent);

    final result = await useCase();

    expect(result, isA<ResultSuccess<RecentAndFavoriteOutfitResponse>>());
    expect(result.data?.favorites, favorites.data);
    expect(result.data?.recent, recent.data);
  });

  test('returns Result.fail with ServerFailure if any call throws ServerException', () async {
    when(() => mockRepository.getFavoriteOutfits())
        .thenThrow(ServerException("Bad gateway", 502));
    when(() => mockRepository.getRecentOutfits())
        .thenAnswer((_) async => OutfitsResponse([]));

    final result = await useCase();

    expect(result, isA<ResultFail<RecentAndFavoriteOutfitResponse>>());
    expect(result.failure, isA<ServerFailure>());
    expect((result.failure as ServerFailure).statusCode, 502);
  });

  test('returns Result.fail with UnknownFailure on unknown exception', () async {
    when(() => mockRepository.getFavoriteOutfits())
        .thenThrow(Exception("Unexpected crash"));
    when(() => mockRepository.getRecentOutfits())
        .thenAnswer((_) async => OutfitsResponse([]));

    final result = await useCase();

    expect(result, isA<ResultFail<RecentAndFavoriteOutfitResponse>>());
    expect(result.failure, isA<UnknownFailure>());
  });

  test('calls success closure in collect()', () async {
    when(() => mockRepository.getFavoriteOutfits())
        .thenAnswer((_) async => OutfitsResponse([]));
    when(() => mockRepository.getRecentOutfits())
        .thenAnswer((_) async => OutfitsResponse([]));

    final result = await useCase();

    String marker = '';
    result.collect(
          (data) => marker = 'success',
          (failure) => marker = 'fail',
    );

    expect(marker, 'success');
  });

  test('calls failure closure in collect()', () async {
    when(() => mockRepository.getFavoriteOutfits())
        .thenThrow(ServerException("Oops", 500));
    when(() => mockRepository.getRecentOutfits())
        .thenAnswer((_) async => OutfitsResponse([]));

    final result = await useCase();

    String marker = '';
    result.collect(
          (data) => marker = 'success',
          (failure) => marker = 'fail',
    );

    expect(marker, 'fail');
  });
}
