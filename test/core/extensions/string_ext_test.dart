import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:style_me/core/extensions/string_ext.dart';

void main() {
  group('Cryptography', () {
    test('getHashed should return SHA-256 hash of the string', () {
      // Arrange
      final input = 'hello';
      final expectedHash = sha256.convert(utf8.encode(input)).toString();

      // Act
      final result = input.getHashed();

      // Assert
      expect(result, expectedHash);
    });

    test('getHashed should return different hashes for different strings', () {
      // Arrange
      final input1 = 'hello';
      final input2 = 'world';

      // Act
      final result1 = input1.getHashed();
      final result2 = input2.getHashed();

      // Assert
      expect(result1, isNot(result2));
    });
  });

  group('CryptographySafe', () {
    test('getHashed should return SHA-256 hash for non-null strings', () {
      // Arrange
      final String? input = 'hello';
      final expectedHash = sha256.convert(utf8.encode(input!)).toString();

      // Act
      final result = input.getHashed();

      // Assert
      expect(result, expectedHash);
    });

    test('getHashed should return null for null strings', () {
      // Arrange
      final String? input = null;

      // Act
      final result = input.getHashed();

      // Assert
      expect(result, null);
    });
  });

  group('TokenExt', () {
    test('withBearer should return token with Bearer prefix', () {
      // Arrange
      final token = 'abc123';
      final expected = 'Bearer abc123';

      // Act
      final result = token.withBearer();

      // Assert
      expect(result, expected);
    });

    test('isTokenExpired should return true for expired token', () {
      // Arrange
      final expiredToken =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MDAwMDAwMDB9.signature';

      // Act
      final result = expiredToken.isTokenExpired();

      // Assert
      expect(result, true);
    });

    test('isTokenExpired should return false for valid token', () {
      // Arrange
      final int futureTime = DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600;
      final validToken =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.${base64Url.encode(utf8.encode('{"exp":$futureTime}'))}.signature';

      // Act
      final result = validToken.isTokenExpired();

      // Assert
      expect(result, false);
    });

    test('isTokenExpired should return true for malformed token', () {
      // Arrange
      final malformedToken = 'this_is_not_a_valid_token';

      // Act
      final result = malformedToken.isTokenExpired();

      // Assert
      expect(result, true);
    });

    test('isTokenExpired should return true for token without exp', () {
      // Arrange
      final tokenWithoutExp =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJub3RfZXhwIjoidGVzdCJ9.signature';

      // Act
      final result = tokenWithoutExp.isTokenExpired();

      // Assert
      expect(result, true);
    });
  });
}
