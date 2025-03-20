import 'dart:io';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pointycastle/export.dart';
import 'package:http/http.dart' as http;
import 'package:style_me/core/extensions/global_ext.dart';

class AESEncryptor {
  static const int keySize = 32;
  static const int ivSize = 16;
  static const int tagSize = 128;

  static Future<File> encryptImage(File imageFile) async {
    final Uint8List key = hexToUint8List(dotenv.env['AES_KEY'] ?? "");
    final imageBytes = await imageFile.readAsBytes();
    final encryptedBytes = _encryptAESGCM(imageBytes, key);

    final tempDir = await getTemporaryDirectory();
    final encryptedFile = File('${tempDir.path}/encrypted_image.enc');
    await encryptedFile.writeAsBytes(encryptedBytes);

    return encryptedFile;
  }

  static Future<Uint8List> decryptImageFrom(String encryptedImageUrl) async {
    try {
      final response = await http.get(Uri.parse(encryptedImageUrl));
      if (response.statusCode == 200) {
        return AESEncryptor.decryptImage(response.bodyBytes);
      } else {
        throw Exception("${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      debugMessagePrint("Failed to load image: $e");
      throw Exception("Failed to load image");
    }
  }

  static Future<Uint8List> decryptImage(Uint8List encryptedImageBytes) async {
    final Uint8List key = hexToUint8List(dotenv.env['AES_KEY'] ?? "");
    final decryptedBytes = _decryptAESGCM(encryptedImageBytes, key);

    return decryptedBytes;
  }

  static Uint8List _encryptAESGCM(Uint8List plainData, Uint8List key) {
    final nonce = _generateRandomNonce();
    final cipher = GCMBlockCipher(AESEngine());

    final parameters = AEADParameters(
      KeyParameter(key),
      tagSize,
      nonce,
      Uint8List(0),
    );
    cipher.init(true, parameters);

    final encrypted = cipher.process(plainData);

    final ciphertextLength = encrypted.length - (tagSize ~/ 8);
    final ciphertext = encrypted.sublist(0, ciphertextLength);
    final tag = encrypted.sublist(ciphertextLength);

    return Uint8List.fromList([...nonce, ...tag, ...ciphertext]);
  }

  static Uint8List _decryptAESGCM(Uint8List encryptedData, Uint8List key) {
    if (encryptedData.length < (ivSize + (tagSize ~/ 8))) {
      throw ArgumentError("Invalid encrypted data length");
    }

    final nonce = encryptedData.sublist(0, ivSize);
    final tag = encryptedData.sublist(ivSize, ivSize + (tagSize ~/ 8));
    final ciphertext = encryptedData.sublist(ivSize + (tagSize ~/ 8));

    final cipher = GCMBlockCipher(AESEngine());
    final parameters = AEADParameters(
      KeyParameter(key),
      tagSize,
      nonce,
      Uint8List(0),
    );

    cipher.init(false, parameters);

    return cipher.process(Uint8List.fromList([...ciphertext, ...tag]));
  }

  static Uint8List _generateRandomNonce() {
    final secureRandom = SecureRandom("Fortuna")
      ..seed(
        KeyParameter(
          Uint8List.fromList(
            List.generate(32, (i) => i),
          ),
        ),
      );
    return secureRandom.nextBytes(ivSize);
  }

  static Uint8List hexToUint8List(String hexString) {
    final bytes = hex.decode(hexString);
    return Uint8List.fromList(bytes);
  }
}
