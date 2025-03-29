import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:style_me/core/extensions/string_ext.dart';

void main() {
  group('Cryptography', () {
    test('getHashed should return SHA-256 hash of the string', () {
      
      final input = 'hello';
      final expectedHash = sha256.convert(utf8.encode(input)).toString();

      
      final result = input.getHashed();

      
      expect(result, expectedHash);
    });

    test('getHashed should return different hashes for different strings', () {
      
      final input1 = 'hello';
      final input2 = 'world';

      
      final result1 = input1.getHashed();
      final result2 = input2.getHashed();

      
      expect(result1, isNot(result2));
    });
  });

  group('CryptographySafe', () {
    test('getHashed should return SHA-256 hash for non-null strings', () {
      
      final String? input = 'hello';
      final expectedHash = sha256.convert(utf8.encode(input!)).toString();

      
      final result = input.getHashed();

      
      expect(result, expectedHash);
    });

    test('getHashed should return null for null strings', () {
      
      final String? input = null;

      
      final result = input.getHashed();

      
      expect(result, null);
    });
  });

  group('TokenExt', () {
    test('withBearer should return token with Bearer prefix', () {
      
      final token = 'abc123';
      final expected = 'Bearer abc123';

      
      final result = token.withBearer();

      
      expect(result, expected);
    });

    test('isTokenExpired should return true for expired token', () {
      
      final expiredToken =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MDAwMDAwMDB9.signature';

      
      final result = expiredToken.isTokenExpired();

      
      expect(result, true);
    });

    test('isTokenExpired should return false for valid token', () {
      
      final int futureTime = DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600;
      final validToken =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.${base64Url.encode(utf8.encode('{"exp":$futureTime}'))}.signature';

      
      final result = validToken.isTokenExpired();

      
      expect(result, false);
    });

    test('isTokenExpired should return true for malformed token', () {
      
      final malformedToken = 'this_is_not_a_valid_token';

      
      final result = malformedToken.isTokenExpired();

      
      expect(result, true);
    });

    test('isTokenExpired should return true for token without exp', () {
      
      final tokenWithoutExp =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJub3RfZXhwIjoidGVzdCJ9.signature';

      
      final result = tokenWithoutExp.isTokenExpired();

      
      expect(result, true);
    });
  });
}
