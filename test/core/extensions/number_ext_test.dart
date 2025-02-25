import 'package:flutter_test/flutter_test.dart';
import 'package:style_me/core/extensions/number_ext.dart';

void main() {
  group('TimeConvert', () {
    test('should convert seconds less than a minute correctly', () {
      // Arrange
      final seconds = 45;

      // Act
      final result = seconds.secondsToString();

      // Assert
      expect(result, '00:45');
    });

    test('should convert exactly one minute correctly', () {
      // Arrange
      final seconds = 60;

      // Act
      final result = seconds.secondsToString();

      // Assert
      expect(result, '01:00');
    });

    test('should convert multiple minutes correctly', () {
      // Arrange
      final seconds = 125;

      // Act
      final result = seconds.secondsToString();

      // Assert
      expect(result, '02:05');
    });

    test('should handle zero seconds', () {
      // Arrange
      final seconds = 0;

      // Act
      final result = seconds.secondsToString();

      // Assert
      expect(result, '00:00');
    });

    test('should handle edge case of exactly 59 seconds', () {
      // Arrange
      final seconds = 59;

      // Act
      final result = seconds.secondsToString();

      // Assert
      expect(result, '00:59');
    });

    test('should handle edge case of exactly 119 seconds', () {
      // Arrange
      final seconds = 119;

      // Act
      final result = seconds.secondsToString();

      // Assert
      expect(result, '01:59');
    });

    test('should handle large values correctly', () {
      // Arrange
      final seconds = 3600;

      // Act
      final result = seconds.secondsToString();

      // Assert
      expect(result, '60:00');
    });

    test('should correctly pad single digit minutes and seconds', () {
      // Arrange
      final seconds = 65;

      // Act
      final result = seconds.secondsToString();

      // Assert
      expect(result, '01:05');
    });
  });
}
