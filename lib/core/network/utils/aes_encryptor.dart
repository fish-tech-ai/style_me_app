import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pointycastle/export.dart';

class AESEncryptor {
  static const int keySize = 32;
  static const int ivSize = 16;
  static const int tagSize = 128;
  final GCMBlockCipher cipher = GCMBlockCipher(AESEngine());
  late final Uint8List key;

  AESEncryptor() {
    key = hexToUint8List(dotenv.env['AES_KEY'] ?? "");
  }

  AESEncryptor.withKey(String key) {
    this.key = hexToUint8List(key);
  }


  Future<File> encryptImage(File imageFile) async {
    final imageBytes = await imageFile.readAsBytes();
    final encryptedBytes = _encryptAESGCM(imageBytes, key);

    final tempDir = await getTemporaryDirectory();
    final encryptedFile = File('${tempDir.path}/encrypted_image.enc');
    await encryptedFile.writeAsBytes(encryptedBytes);

    return encryptedFile;
  }

  Uint8List _encryptAESGCM(Uint8List plainData, Uint8List key) {
    final nonce = generateRandomNonce();

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

  Future<Uint8List> decryptImage(Uint8List encryptedImageBytes) async {
    return _decryptAESGCM(encryptedImageBytes, key);
  }

  Uint8List _decryptAESGCM(Uint8List encryptedData, Uint8List key) {
    if (encryptedData.length < (ivSize + (tagSize ~/ 8))) {
      throw ArgumentError("Invalid encrypted data length");
    }

    final tagLength = tagSize ~/ 8;
    final nonce = Uint8List.view(encryptedData.buffer, 0, ivSize);
    final tag = Uint8List.view(encryptedData.buffer, ivSize, tagLength);
    final ciphertextLength = encryptedData.length - ivSize - tagLength;
    final ciphertext = Uint8List.view(
        encryptedData.buffer, ivSize + tagLength, ciphertextLength);

    final combined = Uint8List(ciphertextLength + tagLength);
    combined.setRange(0, ciphertextLength, ciphertext);
    combined.setRange(ciphertextLength, combined.length, tag);

    final cipher = GCMBlockCipher(AESEngine());
    final parameters = AEADParameters(
      KeyParameter(key),
      tagSize,
      nonce,
      Uint8List(0),
    );

    cipher.init(false, parameters);

    return cipher.process(combined);
  }

  Uint8List generateRandomNonce() {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final timestampBytes = ByteData(8)..setInt64(0, timestamp);

    final random = Random.secure();
    final randomBytes = Uint8List.fromList(
      List.generate(8, (_) => random.nextInt(256)),
    );

    return Uint8List.fromList(
        [...timestampBytes.buffer.asUint8List(), ...randomBytes]);
  }

  Uint8List hexToUint8List(String hexString) {
    final bytes = hex.decode(hexString);
    return Uint8List.fromList(bytes);
  }
}
