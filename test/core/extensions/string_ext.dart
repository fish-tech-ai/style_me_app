import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:style_me/core/extensions/string_ext.dart';

void main() {
  group('isTokenExpired Tests', () {
    test('Expired token should return true', () {
      final expiredToken = generateJwtToken(expiryInSeconds: -3600);
      expect(expiredToken.isTokenExpired(), isTrue);
    });

    test('Valid token (future expiration) should return false', () {
      final validToken = generateJwtToken(expiryInSeconds: 3600);
      expect(validToken.isTokenExpired(), isFalse);
    });

    test('Malformed JWT should return true', () {
      const malformedToken = "invalid.jwt.token";
      expect(malformedToken.isTokenExpired(), isTrue);
    });

    test('Token without exp should return true', () {
      final tokenWithoutExp = generateJwtToken(includeExp: false);
      expect(tokenWithoutExp.isTokenExpired(), isTrue);
    });

    test('Token with invalid base64 payload should return true', () {
      const invalidBase64Token =
          "eyJhbGciOiJIUzI1NiJ9.invalidpayload.XA9bEjmsPXaQK2xF4lyVujsJuUEHyltxcGVFnwpjMzA";
      expect(invalidBase64Token.isTokenExpired(), isTrue);
    });
  });

  group('getHashed Tests', () {
    test('Hashing a known string should return expected hash', () {
      const input = "hello world";
      const expectedHash =
          "b94d27b9934d3e08a52e52d7da7dabfac484efe37a5380ee9088f7ace2efcde9";
      expect(input.getHashed(), expectedHash);
    });

    test('Hashing an empty string should return correct hash', () {
      const emptyString = "";
      const expectedHash =
          "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855";
      expect(emptyString.getHashed(), expectedHash);
    });

    test('Hashing different strings should produce different hashes', () {
      const string1 = "string1";
      const string2 = "string2";

      final hash1 = string1.getHashed();
      final hash2 = string2.getHashed();

      expect(hash1, isNot(equals(hash2)));
    });

    test('Hashing the same string multiple times should be consistent', () {
      const input = "consistency test";

      final hash1 = input.getHashed();
      final hash2 = input.getHashed();

      expect(hash1, equals(hash2));
    });
  });
}

String generateJwtToken({int expiryInSeconds = 3600, bool includeExp = true}) {
  final header = base64Url.encode(utf8.encode(json.encode({"alg": "HS256"})));

  final payloadData = {
    "sub": "test@example.com",
    "iat": DateTime.now().millisecondsSinceEpoch ~/ 1000,
  };

  if (includeExp) {
    payloadData["exp"] =
        DateTime.now().millisecondsSinceEpoch ~/ 1000 + expiryInSeconds;
  }

  final payload = base64Url.encode(utf8.encode(json.encode(payloadData)));
  final signature =
      base64Url.encode(utf8.encode("signature")); // Mock signature

  return "$header.$payload.$signature";
}
