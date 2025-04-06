import 'package:flutter_test/flutter_test.dart';
import 'package:style_me/core/network/failures/failure.dart';
import 'package:style_me/core/network/failures/server_failure.dart';

class _FakeFailure extends Failure {
  _FakeFailure(super.message);
}

void main() {
  group('Failure', () {
    test('stores and returns the message', () {
      final failure = ServerFailure('Something went wrong', 500);
      expect(failure.message, 'Something went wrong');
    });

    test('toString returns message if provided', () {
      final failure = ServerFailure('Boom!', 400);
      expect(failure.toString(), 'Boom!');
    });

    test('toString falls back to super.toString() when message is null', () {
      final failure = ServerFailure(null, 400);
      expect(failure.toString(), contains('Instance of'));
    });

    group('isStatusCodeEquals', () {
      test('returns true when status code matches', () {
        final failure = ServerFailure('Error', 403);
        expect(failure.isStatusCodeEquals(403), true);
      });

      test('returns false when status code does not match', () {
        final failure = ServerFailure('Error', 401);
        expect(failure.isStatusCodeEquals(403), false);
      });

      test('returns false when not a ServerFailure', () {
        final failure = _FakeFailure('Some error');
        expect(failure.isStatusCodeEquals(500), false);
      });
    });
  });
}
