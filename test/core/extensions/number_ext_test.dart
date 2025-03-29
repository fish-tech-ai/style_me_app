import 'package:flutter_test/flutter_test.dart';
import 'package:style_me/core/extensions/number_ext.dart';

void main() {
  group('TimeConvert', () {
    test('should convert seconds less than a minute correctly', () {
      
      final seconds = 45;

      
      final result = seconds.secondsToString();

      
      expect(result, '00:45');
    });

    test('should convert exactly one minute correctly', () {
      
      final seconds = 60;

      
      final result = seconds.secondsToString();

      
      expect(result, '01:00');
    });

    test('should convert multiple minutes correctly', () {
      
      final seconds = 125;

      
      final result = seconds.secondsToString();

      
      expect(result, '02:05');
    });

    test('should handle zero seconds', () {
      
      final seconds = 0;

      
      final result = seconds.secondsToString();

      
      expect(result, '00:00');
    });

    test('should handle edge case of exactly 59 seconds', () {
      
      final seconds = 59;

      
      final result = seconds.secondsToString();

      
      expect(result, '00:59');
    });

    test('should handle edge case of exactly 119 seconds', () {
      
      final seconds = 119;

      
      final result = seconds.secondsToString();

      
      expect(result, '01:59');
    });

    test('should handle large values correctly', () {
      
      final seconds = 3600;

      
      final result = seconds.secondsToString();

      
      expect(result, '60:00');
    });

    test('should correctly pad single digit minutes and seconds', () {
      
      final seconds = 65;

      
      final result = seconds.secondsToString();

      
      expect(result, '01:05');
    });
  });
}
