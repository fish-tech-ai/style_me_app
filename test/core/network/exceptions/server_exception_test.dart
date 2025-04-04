import 'package:flutter_test/flutter_test.dart';
import 'package:style_me/core/network/exceptions/server_exception.dart';

void main() {
  group('ServerException', () {
    test('should store message and status code', () {
      final exception = ServerException('Something went wrong', 500);

      expect(exception.message, 'Something went wrong');
      expect(exception.statusCode, 500);
    });

    test('toString returns message when available', () {
      final exception = ServerException('Oops!');

      expect(exception.toString(), 'Oops!');
    });

    test('toString returns fallback when message is null', () {
      final exception = ServerException(null);

      expect(exception.toString(), 'Message not provided');
    });
  });
}
