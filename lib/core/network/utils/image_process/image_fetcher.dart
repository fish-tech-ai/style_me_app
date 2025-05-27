import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:style_me/core/app/domain/usecases/fetch_image_use_case.dart';
import 'package:style_me/features/wardrobe/data/models/photo_item.dart';

///[ImageFetcher] is responsible for downloading from url and loading images or image into the cache (files).
class ImageFetcher {
  final FetchImageUseCase _fetchImageUseCase;

  ImageFetcher(this._fetchImageUseCase);

  /// Downloads images from the URLs in the given [itemsWithUrls] list and caches them
  /// as local files in the temporary directory.
  ///
  /// Each [PhotoItem] in the list must contain a valid URL in its [image] field.
  /// The function generates a corresponding local file path for each image based on
  /// its [id], downloads the image from the URL, and saves it to the local path.
  ///
  /// Returns a new list of [PhotoItem]s where each item's [image] field is replaced
  /// with the path to its cached file.
  ///
  Future<List<PhotoItem>> downloadImagesToCachePaths(List<PhotoItem> itemsWithUrls, {String suffix = ""}) async {
    final cacheDir = await getTemporaryDirectory();
    final List<PhotoItem> itemsWithPaths = itemsWithUrls.map(
          (item) {
        return item.copyWith(
            image: '${cacheDir.path}/${item.id}$suffix.webp');
      },
    ).toList();
    await _downloadAndCacheImages(
      itemsWithUrls
          .map((itemWithUrl) => itemWithUrl.image)
          .toList(),
      itemsWithPaths
          .map((itemWithPath) => itemWithPath.image)
          .toList(),
    );
    return itemsWithPaths;
  }

  Future downloadAndCacheImage(String url, String path) async {
    final imagesBytes = (await _fetchImages([url])).first;
    final File imageFile = File(path);
    await imageFile.writeAsBytes(imagesBytes);
  }

  Future _downloadAndCacheImages(
      List<String> urls, List<String> paths) async {
    final imagesBytesList = await _fetchImages(urls);

    final Map<String, Uint8List> pathToImageBytesMap =
        Map.fromIterables(paths, imagesBytesList);

    for (final MapEntry(key: path, value: bytes)
        in pathToImageBytesMap.entries) {
      final File imageFile = File(path);
      await imageFile.writeAsBytes(bytes);
    }
  }

  Future<List<Uint8List>> _fetchImages(List<String> encryptedImageUrls) async {
    final decryptedBytesList = encryptedImageUrls.map((imageUrl) async {
      final encryptedImageBytes = await _fetchImageUseCase.call(imageUrl);
      return encryptedImageBytes;
    });

    return await Future.wait(decryptedBytesList);
  }
}
