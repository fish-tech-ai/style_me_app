import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:gal/gal.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:style_me/core/extensions/global_ext.dart';
import 'package:style_me/core/network/exceptions/helpers/image_error_type/image_type_enum.dart';
import 'package:style_me/core/network/failures/gal_failure.dart';
import 'package:style_me/core/network/failures/image_process_failure.dart';
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
    final String imagePath = '${cacheDir.path}/${photoId}_download_temp.webp';

    await _imageFetcher.downloadAndCacheImage(
        response.originalOutfitUrl, imagePath);

    final Uint8List imageBytes =
        await decryptManager.getDecryptedImageBytes(imagePath);

    final Uint8List imageBytesJpg;
    try {
      imageBytesJpg = _convertToJpg(imageBytes);
    } catch (e) {
      return Result.fail(
          ImageProcessFailure(e.toString(), ImageErrorTypeEnum.CANT_PROCESS));
    }

    return saveToGallery(imageBytesJpg, imagePath, name);
  }

  Uint8List _convertToJpg(Uint8List imageBytes) {
    final decodedImage = decodeWebP(imageBytes);
    if (decodedImage == null) {
      debugMessagePrint("Cannot decode to webP");
      throw CompressError("Unsupported file type (webP)");
    }
    return encodeJpg(decodedImage);
  }

  Future<Result> saveToGallery(
      Uint8List imageBytesJpg, String imagePath, String name) async {
    try {
      await Gal.putImageBytes(imageBytesJpg, name: name);
      File(imagePath).delete();
      return Result.success(null);
    } on GalException catch (e) {
      return Result.fail(GalFailure(e.type, e.type.message));
    } catch (e) {
      debugMessagePrint(e.toString());
      return Result.success(null);
    }
  }
}
