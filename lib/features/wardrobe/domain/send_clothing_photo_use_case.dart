import 'dart:io';

import 'package:style_me/core/extensions/file_ext.dart';
import 'package:style_me/core/extensions/global_ext.dart';
import 'package:style_me/core/network/utils/aes_encryptor.dart';
import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/wardrobe/data/models/io/send_clothing_photo_response.dart';
import 'package:style_me/features/wardrobe/data/wardrobe_repository.dart';

class SendClothingPhotoUseCase {
  final WardrobeRepository _repository;
  final NetworkRequestUtil _networkUtil;

  SendClothingPhotoUseCase(this._repository, this._networkUtil);

  Future<Result<SendClothingPhotoResponse>> call(File image) async {
    final compressedImage = await image.getCompressed();
    final encryptedFile = await AESEncryptor.encryptImage(compressedImage);
    return _networkUtil.makeRepositoryRequest(
      () async {
        final SendClothingPhotoResponse result =
            await _repository.sendClothingPhoto(encryptedFile);
        return result;
      },
      onSuccess: (_) => deleteFiles(
        image,
        compressedImage,
        encryptedFile,
      ),
      onError: (_) => deleteFiles(
        image,
        compressedImage,
        encryptedFile,
      ),
    );
  }

  Future deleteFiles(
      File imageFile, File compressedImageFile, File encryptedFile) async {
    Directory? parentDir = imageFile.parent;
    try {
      await imageFile.delete();
      await compressedImageFile.delete();
      await encryptedFile.delete();
      if (parentDir.existsSync() && parentDir.listSync().isEmpty) {
        await parentDir.delete();
      }
    } catch (e) {
      debugMessagePrint("Error deleting cache files: $e");
    }
  }
}
