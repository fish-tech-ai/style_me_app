import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:gal/gal.dart';
import 'package:image/image.dart';
import 'package:style_me/core/network/failures/gal_failure.dart';
import 'package:style_me/core/network/failures/permission_failure.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/core/views/encrypted_image/isolated_decrypt_manager.dart';

class DownloadToGalleryWithPermissionsUseCase {
  final IsolatedDecryptManager decryptManager;

  DownloadToGalleryWithPermissionsUseCase(this.decryptManager);

  Future<Result> call(String photoPath, String name) async {
    if (!await Gal.requestAccess()) {
      return Result.fail(
          PermissionFailure("Storage write permissions are missing"));
    }

    final Uint8List imageBytes =
        await decryptManager.getDecryptedImageBytes(photoPath);
    final decodedImage = decodeWebP(imageBytes);
    if (decodedImage == null) {
      throw CompressError("Cannot decode to webP");
    }
    final convertedImageBytes = encodeJpg(decodedImage);
    try {
      await Gal.putImageBytes(convertedImageBytes, name: name);
      return Result.success(null);
    } on GalException catch (e) {
      return Result.fail(GalFailure(e.type, e.type.message));
    }
  }
}
