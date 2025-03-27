import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart';
import 'package:style_me/core/app/domain/usecases/fetch_image_use_case.dart';
import 'package:style_me/core/extensions/global_ext.dart';
import 'package:style_me/core/network/utils/aes_encryptor.dart';

class EncryptedImageFetcher {
  final AESEncryptor _encryptor;
  final FetchImageUseCase _fetchImageUseCase;

  EncryptedImageFetcher(this._encryptor, this._fetchImageUseCase);

  Future<Uint8List> fetchAndDecryptImageFrom(String encryptedImageUrl) async {
    final startOfFunction = DateTime.now().millisecondsSinceEpoch;
    final encryptedImageBytes = await _fetchImageUseCase(encryptedImageUrl);
    debugMessagePrint("_fetchImageUseCase: ${DateTime.now().millisecondsSinceEpoch - startOfFunction}");
    final decryptedImage = await _encryptor.decryptImage(encryptedImageBytes);
    debugMessagePrint("decryptedImage: ${DateTime.now().millisecondsSinceEpoch - startOfFunction}");
    Image? image = decodeImage(decryptedImage);
    if (image == null) {
      throw CompressError("Failed to decode image from EncryptedImageFetcher: getCompressed()");
    }
    int newWidth = 200;
    int newHeight = (image.height * newWidth / image.width).round();
    Uint8List? compressedBytes = await FlutterImageCompress.compressWithList(
        decryptedImage,
        minWidth: newWidth,
        minHeight: newHeight,
    );
    debugMessagePrint("compressed image: ${DateTime.now().millisecondsSinceEpoch - startOfFunction}");
    return compressedBytes;
  }
}
