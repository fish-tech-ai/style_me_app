import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:chopper/chopper.dart';
import 'package:style_me/core/network/exceptions/server_exception.dart';
import 'package:style_me/core/network/services/outfit_service.dart';
import 'package:style_me/features/checkroom/data/models/generate_outfit_body.dart';
import 'package:style_me/features/checkroom/data/models/generated_outfit_response.dart';
import 'package:style_me/features/home/data/models/outfit_original_photo_response.dart';
import 'package:style_me/features/home/data/models/outfits_response.dart';
import 'package:style_me/features/home/data/outfit_repository.dart';

class MockOutfitService extends Mock implements OutfitService {}

base class MockResponse<T> extends Mock with MockResponseMixin<T> {}

void main() {
  late MockOutfitService mockService;
  late OutfitRepository repository;

  setUp(() {
    mockService = MockOutfitService();
    repository = OutfitRepository(mockService);
  });

  group('OutfitRepository', () {
    test('generateOutfit returns GeneratedOutfitResponse on success', () async {
      final request = GenerateOutfitBody("", "", "", "");
      final expectedBody = GeneratedOutfitResponse("", "");
      final mockResponse = MockResponse<GeneratedOutfitResponse>();

      when(() => mockResponse.isSuccessful).thenReturn(true);
      when(() => mockResponse.body).thenReturn(expectedBody);

      when(() => mockService.generateOutfit(request))
          .thenAnswer((_) async => mockResponse);

      final result = await repository.generateOutfit(request);
      expect(result, expectedBody);
    });

    test('generateOutfit throws ServerException on failure', () async {
      final request = GenerateOutfitBody("", "", "", "");
      final mockResponse = MockResponse<GeneratedOutfitResponse>();

      when(() => mockResponse.isSuccessful).thenReturn(false);
      when(() => mockResponse.error).thenReturn('Error occurred');
      when(() => mockResponse.statusCode).thenReturn(500);

      when(() => mockService.generateOutfit(request))
          .thenAnswer((_) async => mockResponse);

      expect(() => repository.generateOutfit(request),
          throwsA(isA<ServerException>()));
    });

    test('getRecentOutfits returns OutfitsResponse on success', () async {
      final expected = OutfitsResponse([]);
      final mockResponse = MockResponse<OutfitsResponse>();

      when(() => mockResponse.isSuccessful).thenReturn(true);
      when(() => mockResponse.body).thenReturn(expected);

      when(() => mockService.getRecentOutfits())
          .thenAnswer((_) async => mockResponse);

      final result = await repository.getRecentOutfits();
      expect(result, expected);
    });

    test('getFavoriteOutfits returns OutfitsResponse on success', () async {
      final expected = OutfitsResponse([]);
      final mockResponse = MockResponse<OutfitsResponse>();

      when(() => mockResponse.isSuccessful).thenReturn(true);
      when(() => mockResponse.body).thenReturn(expected);

      when(() => mockService.getFavoriteOutfits())
          .thenAnswer((_) async => mockResponse);

      final result = await repository.getFavoriteOutfits();
      expect(result, expected);
    });

    test('getOriginalOutfitPhoto returns OutfitOriginalPhotoResponse',
        () async {
      final outfitId = '123';
      final expected = OutfitOriginalPhotoResponse("");
      final mockResponse = MockResponse<OutfitOriginalPhotoResponse>();

      when(() => mockResponse.isSuccessful).thenReturn(true);
      when(() => mockResponse.body).thenReturn(expected);

      when(() => mockService.getOriginalOutfitUrl(outfitId))
          .thenAnswer((_) async => mockResponse);

      final result = await repository.getOriginalOutfitPhoto(outfitId);
      expect(result, expected);
    });

    test('setIsOutfitFavorite completes on success', () async {
      final outfitId = '123';
      final mockResponse = MockResponse<void>();

      when(() => mockResponse.isSuccessful).thenReturn(true);

      when(() => mockService.likeOutfit(outfitId, true))
          .thenAnswer((_) async => mockResponse);

      await repository.setIsOutfitFavorite(outfitId, true);

      verify(() => mockService.likeOutfit(outfitId, true)).called(1);
    });

    test('setIsOutfitFavorite throws ServerException on failure', () async {
      final outfitId = '123';
      final mockResponse = MockResponse<void>();

      when(() => mockResponse.isSuccessful).thenReturn(false);
      when(() => mockResponse.error).thenReturn('Failed');
      when(() => mockResponse.statusCode).thenReturn(500);

      when(() => mockService.likeOutfit(outfitId, true))
          .thenAnswer((_) async => mockResponse);

      expect(() => repository.setIsOutfitFavorite(outfitId, true),
          throwsA(isA<ServerException>()));
    });
  });
}
