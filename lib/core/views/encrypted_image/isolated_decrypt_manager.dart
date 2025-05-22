import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:isolate_manager/isolate_manager.dart';
import 'package:style_me/core/extensions/global_ext.dart';
import 'package:style_me/core/network/utils/aes_encryptor.dart';
import 'package:style_me/core/views/encrypted_image/isolated_encrypted_image_fetcher_args.dart';

class IsolatedDecryptManager {
  final IsolateManager<Uint8List, IsolatedDecryptBytesArgs> isolateManger =
      IsolateManager.create(isolatedDecrypt, concurrent: 4);

  Future<Uint8List> getDecryptedImageBytes(String path) async {
    final aesKey = dotenv.env['AES_KEY'] ?? '';
    final decryptedBytes =
        await isolateManger.compute(IsolatedDecryptBytesArgs(path, aesKey));
    return decryptedBytes;
  }

  static Future<Uint8List> isolatedDecrypt(
      IsolatedDecryptBytesArgs args) async {
    final startOfFunction = DateTime.now().millisecondsSinceEpoch;
    final encryptedBytes = await File(args.path).readAsBytes();
    final encryptor = AESEncryptor.withKey(args.aesKeyHex);
    final decryptedBytes = await encryptor.decryptImage(encryptedBytes);
    debugMessagePrint(
        "decrypt took: ${DateTime.now().millisecondsSinceEpoch - startOfFunction} milis");
    return decryptedBytes;
  }
}
