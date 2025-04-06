import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:style_me/core/app/domain/usecases/fetch_image_use_case.dart';
import 'dart:io';

import 'package:style_me/core/network/utils/image_process/image_fetcher.dart';

import '../../helpers/shared_test_functions.dart';

class MockFetchImageUseCase extends Mock implements FetchImageUseCase {}

void main() {
  mockGetTemporaryDirectory();

  late ImageFetcher imageFetcher;
  late MockFetchImageUseCase mockFetchImageUseCase;

  setUp(() {
    mockFetchImageUseCase = MockFetchImageUseCase();
    imageFetcher = ImageFetcher(mockFetchImageUseCase);
  });

  group('ImageFetcher', () {
    test(
        'handleSingleImageLoadingAndCache downloads and caches image', () async {
      const url = 'http://example.com/w5L15tYmw2FVKBFG6OE9.jpg';
      const path = './w5L15tYmw2FVKBFG6OE9.jpg';
      final mockImageBytes = Uint8List.fromList([0, 1, 2, 3]);

      when(() => mockFetchImageUseCase.call(url))
          .thenAnswer((_) async => mockImageBytes);

      await imageFetcher.handleSingleImageLoadingAndCache(url, path);

      final file = File(path);
      expect(await file.exists(), true);
      expect(await file.readAsBytes(), mockImageBytes);

      verify(() => mockFetchImageUseCase.call(url)).called(1);
      file.delete();
    });

    test(
        'handleImagesLoadingAndCache downloads and caches multiple images', () async {
      const urls = [
        'http://example.com/image1.jpg',
        'http://example.com/image2.jpg'
      ];
      const paths = ['./w5L15tYmw2FVKBFG6OE9.jpg', './w5L15tYmw2FVKBFG6OE92.jpg'];
      final mockImageBytesList = [
        Uint8List.fromList([0, 1, 2, 3]),
        Uint8List.fromList([4, 5, 6, 7]),
      ];

      for (var i = 0; i < urls.length; i++) {
        when(() => mockFetchImageUseCase.call(urls[i]))
            .thenAnswer((_) async => mockImageBytesList[i]);
      }

      await imageFetcher.handleImagesLoadingAndCache(urls, paths);

      List<File> files = [];
      for (var i = 0; i < paths.length; i++) {
        final file = File(paths[i]);
        expect(await file.exists(), true);
        expect(await file.readAsBytes(), mockImageBytesList[i]);
        files.add(file);
      }

      for (var url in urls) {
        verify(() => mockFetchImageUseCase.call(url)).called(1);
      }

      for (var file in files) {
        file.delete();
      }
    });
  });
}
