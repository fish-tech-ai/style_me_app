import 'dart:typed_data';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:http/http.dart' as http;
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:style_me/core/network/utils/aes_encryptor.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockHttpResponse extends Mock implements http.Response {}

class MockPathProvider extends Mock
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {}

void main() {
  late MockPathProvider mockPathProvider;
  late AESEncryptor encryptor;

  setUpAll(() async {
    mockPathProvider = MockPathProvider();
    final key = List.generate(32, (i) => i)
        .map((e) => e.toRadixString(16).padLeft(2, '0'))
        .join();
    dotenv.testLoad(fileInput: "AES_KEY=$key");
    encryptor = AESEncryptor.withKey(key);

    PathProviderPlatform.instance = mockPathProvider;

    registerFallbackValue(Uri.parse('https://fake.url'));
  });

  group('AESEncryptor', () {
    test('hexToUint8List returns correct bytes', () {
      const hexStr = "00112233445566778899aabbccddeeff";
      final result = encryptor.hexToUint8List(hexStr);
      expect(result, isA<Uint8List>());
      expect(result.length, 16);
    });

    test('encryptImage writes an encrypted file', () async {
      final tempDir = Directory.systemTemp.createTempSync();
      when(() => mockPathProvider.getTemporaryPath())
          .thenAnswer((_) async => tempDir.path);

      final key = List.generate(32, (i) => i)
          .map((e) => e.toRadixString(16).padLeft(2, '0'))
          .join();
      dotenv.testLoad(fileInput: "AES_KEY=$key");

      final testFile = File('${tempDir.path}/test.jpg');
      await testFile.writeAsBytes(List.filled(32, 1));

      final encrypted = await encryptor.encryptImage(testFile);
      expect(await encrypted.exists(), true);
      expect(await encrypted.length(), greaterThan(0));
    });

    test('decryptImage properly decrypts bytes', () async {
      final tempDir = Directory.systemTemp.createTempSync();
      when(() => mockPathProvider.getTemporaryPath())
          .thenAnswer((_) async => tempDir.path);

      final key = List.generate(32, (i) => i)
          .map((e) => e.toRadixString(16).padLeft(2, '0'))
          .join();
      dotenv.testLoad(fileInput: "AES_KEY=$key");

      final testFile = File('${tempDir.path}/test.jpg');
      final originalBytes = List.filled(32, 1);
      await testFile.writeAsBytes(originalBytes);

      final encrypted = await encryptor.encryptImage(testFile);
      final encryptedBytes = await encrypted.readAsBytes();
      final decrypted = await encryptor.decryptImage(encryptedBytes);
      expect(decrypted, equals(originalBytes));
    });
  });
  group('generateRandomNonce', () {
    test('returns 16 bytes', () {
      final nonce = encryptor.generateRandomNonce();
      expect(nonce.length, 16);
    });

    test('contains timestamp in first 8 bytes', () {
      final nonce1 = encryptor.generateRandomNonce();
      final nonce2 = encryptor.generateRandomNonce();

      final time1 = ByteData.sublistView(nonce1, 0, 8).getInt64(0);
      final time2 = ByteData.sublistView(nonce2, 0, 8).getInt64(0);

      expect(time2, greaterThanOrEqualTo(time1));
    });

    test('generates unique nonces', () {
      final Set<String> nonces = <String>{};

      for (int i = 0; i < 100; i++) {
        final nonce = encryptor.generateRandomNonce();
        nonces.add(nonce.join(','));
      }
      expect(nonces.length, 100);
    });
  });
}
