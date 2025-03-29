import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image/image.dart';
import 'package:isolate_manager/isolate_manager.dart';
import 'package:style_me/core/extensions/global_ext.dart';
import 'package:style_me/core/network/utils/aes_encryptor.dart';
import 'package:style_me/core/views/encrypted_image/isolated_encrypted_image_fetcher_args.dart';

class IsolatedDecryptCompressManager {
  final IsolateManager<Uint8List, IsolatedDecryptBytesArgs> isolateManger =
  IsolateManager.create(isolatedDecrypt, concurrent: 4);

  Future<Uint8List> getDecryptedImageBytes(String path) async {
    final aesKey = dotenv.env['AES_KEY'] ?? '';
    final decryptedBytes = await isolateManger.compute(
        IsolatedDecryptBytesArgs(path, aesKey));
    return decryptedBytes;
  }

  static Future<Uint8List> isolatedDecrypt(
      IsolatedDecryptBytesArgs args) async {
    final startOfFunction = DateTime
        .now()
        .millisecondsSinceEpoch;
    final encryptedBytes = await File(args.path).readAsBytes();
    final encryptor = AESEncryptor.withKey(args.aesKeyHex);
    final decryptedBytes = await encryptor.decryptImage(encryptedBytes);
    final compressedBytes = _getCompressed(decryptedBytes);
    debugMessagePrint(
        "decrypt and compress took: ${DateTime
            .now()
            .millisecondsSinceEpoch - startOfFunction} milis");
    return compressedBytes;
  }

  static Future<Uint8List> _getCompressed(Uint8List bytes) async {
    final image = decodeImage(bytes);
    if (image == null) {
      throw Exception("Failed to decode image");
    }
    const newWidth = 400;
    final newHeight = (image.height * newWidth / image.width).round();
    final resized = copyResize(image, width: newWidth, height: newHeight);
    final compressedBytes = Uint8List.fromList(encodeJpg(resized, quality: 85));
    return compressedBytes;
  }
}
