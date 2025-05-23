import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:gal/gal.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:style_me/core/extensions/global_ext.dart';
import 'package:style_me/core/network/failures/gal_failure.dart';
import 'package:style_me/core/network/failures/permission_failure.dart';
import 'package:style_me/core/network/utils/image_process/image_fetcher.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/core/views/encrypted_image/isolated_decrypt_manager.dart';
import 'package:style_me/features/home/data/outfit_repository.dart';

class DownloadToGalleryWithPermissionsUseCase {
  final IsolatedDecryptManager decryptManager;
  final ImageFetcher _imageFetcher;
  final OutfitRepository _repository;

  DownloadToGalleryWithPermissionsUseCase(
      this.decryptManager, this._imageFetcher, this._repository);

  Future<Result> call(String photoId, String name) async {
    if (!await Gal.requestAccess()) {
      return Result.fail(
          PermissionFailure("Storage write permissions are missing"));
    }

    final response = await _repository.getOriginalOutfitPhoto(photoId);

    final cacheDir = await getTemporaryDirectory();
    final String originalImagePath =
        '${cacheDir.path}/${photoId}_download_temp.webp';
    await _imageFetcher.downloadAndCacheImage(
        response.originalOutfitUrl, originalImagePath);
    final Uint8List imageBytes =
        await decryptManager.getDecryptedImageBytes(originalImagePath);
    final decodedImage = decodeWebP(imageBytes);
    if (decodedImage == null) {
      throw CompressError("Cannot decode to webP");
    }
    final convertedImageBytes = encodeJpg(decodedImage);
    try {
      await Gal.putImageBytes(convertedImageBytes, name: name);
      File(originalImagePath).delete();
      return Result.success(null);
    } on GalException catch (e) {
      return Result.fail(GalFailure(e.type, e.type.message));
    } catch (e) {
      debugMessagePrint(e.toString());
      return Result.success(null);
    }
  }
}
