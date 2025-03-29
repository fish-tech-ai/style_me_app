import 'dart:io';
import 'dart:typed_data';

import 'package:style_me/core/app/domain/usecases/fetch_image_use_case.dart';

class MultipleImageFetcher {
  final FetchImageUseCase fetchImageUseCase;

  MultipleImageFetcher(this.fetchImageUseCase);

  Future handleImagesLoadingAndCache(List<String> urls, List<String> paths) async {
    final imagesBytesList = await _fetchImages(urls);

    final Map<String, Uint8List> pathToImageBytesMap =
        Map.fromIterables(paths, imagesBytesList);

    for (final MapEntry(key: path, value: bytes)
        in pathToImageBytesMap.entries) {
      final File imageFile = File(path);
      await imageFile.writeAsBytes(bytes);
    }
  }

  Future<List<Uint8List>> _fetchImages(
      List<String> encryptedImageUrls) async {
    final decryptedBytesList = encryptedImageUrls.map((imageUrl) async {
      final encryptedImageBytes = await fetchImageUseCase.call(imageUrl);
      return encryptedImageBytes;
    });

    return await Future.wait(decryptedBytesList);
  }
}
