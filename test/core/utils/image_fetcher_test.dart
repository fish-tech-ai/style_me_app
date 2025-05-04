import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:style_me/core/app/domain/usecases/fetch_image_use_case.dart';
import 'dart:io';

import 'package:style_me/core/network/utils/image_process/image_fetcher.dart';
import 'package:style_me/features/wardrobe/data/models/user_photos/user_photo.dart';

import '../../helpers/shared_test_functions.dart';

class MockFetchImageUseCase extends Mock implements FetchImageUseCase {}

void main() async {
  late ImageFetcher imageFetcher;
  late MockFetchImageUseCase mockFetchImageUseCase;

  setUp(() {
    mockFetchImageUseCase = MockFetchImageUseCase();
    imageFetcher = ImageFetcher(mockFetchImageUseCase);
    mockGetTemporaryDirectory();
  });

  group('ImageFetcher', () {
    test('handleSingleImageLoadingAndCache downloads and caches image',
        () async {
      const url = 'http://example.com/w5L15tYmw2FVKBFG6OE9.jpg';
      const path = './w5L15tYmw2FVKBFG6OE9.jpg';
      final mockImageBytes = Uint8List.fromList([0, 1, 2, 3]);

      when(() => mockFetchImageUseCase.call(url))
          .thenAnswer((_) async => mockImageBytes);

      await imageFetcher.downloadAndCacheImage(url, path);

      final file = File(path);
      expect(await file.exists(), true);
      expect(await file.readAsBytes(), mockImageBytes);

      verify(() => mockFetchImageUseCase.call(url)).called(1);
      file.delete();
    });

    test('downloads and caches images correctly', () async {
      final imageBytes = Uint8List.fromList([1, 2, 3]);

      final photoItemsWithUrls = [
        UserPhoto('1', 'http://example.com/image1.webp', ""),
        UserPhoto('2', 'http://example.com/image2.webp', ""),
      ];

      when(() => mockFetchImageUseCase.call(any()))
          .thenAnswer((_) async => imageBytes);

      final result =
          await imageFetcher.downloadImagesToCachePaths(photoItemsWithUrls);

      expect(result.length, 2);

      for (final photo in result) {
        final file = File(photo.image);
        expect(await file.exists(), isTrue);
        expect(await file.readAsBytes(), imageBytes);
      }

      // Ensure correct calls were made
      verify(() => mockFetchImageUseCase.call('http://example.com/image1.webp'))
          .called(1);
      verify(() => mockFetchImageUseCase.call('http://example.com/image2.webp'))
          .called(1);
    });
  });
}
