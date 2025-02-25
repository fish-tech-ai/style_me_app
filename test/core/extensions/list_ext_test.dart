import 'package:flutter_test/flutter_test.dart';
import 'package:style_me/core/extensions/list_ext.dart';

void main() {
  group('FirstWhereExt', () {
    test('should return the first matching element', () {
      // Arrange
      final list = [1, 2, 3, 4, 5];

      // Act
      final result = list.firstWhereOrNull((element) => element > 3);

      // Assert
      expect(result, 4);
    });

    test('should return null when no elements match', () {
      // Arrange
      final list = [1, 2, 3, 4, 5];

      // Act
      final result = list.firstWhereOrNull((element) => element > 10);

      // Assert
      expect(result, null);
    });

    test('should return null when the list is empty', () {
      // Arrange
      final list = <int>[];

      // Act
      final result = list.firstWhereOrNull((element) => element > 0);

      // Assert
      expect(result, null);
    });

    test('should return the first occurrence when multiple elements match', () {
      // Arrange
      final list = [1, 2, 3, 4, 5, 6];

      // Act
      final result = list.firstWhereOrNull((element) => element % 2 == 0);

      // Assert
      expect(result, 2); // The first even number
    });

    test('should work with custom objects', () {
      // Arrange
      final users = [
        User(id: 1, name: 'Alice'),
        User(id: 2, name: 'Bob'),
        User(id: 3, name: 'Charlie')
      ];

      // Act
      final result =
          users.firstWhereOrNull((user) => user.name.startsWith('B'));

      // Assert
      expect(result?.name, 'Bob');
    });
  });
}

class User {
  final int id;
  final String name;

  User({required this.id, required this.name});
}
