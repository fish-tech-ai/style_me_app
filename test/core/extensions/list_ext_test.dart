import 'package:flutter_test/flutter_test.dart';
import 'package:style_me/core/extensions/list_ext.dart';

void main() {
  group('FirstWhereExt', () {
    test('should return the first matching element', () {
      
      final list = [1, 2, 3, 4, 5];

      
      final result = list.firstWhereOrNull((element) => element > 3);

      
      expect(result, 4);
    });

    test('should return null when no elements match', () {
      
      final list = [1, 2, 3, 4, 5];

      
      final result = list.firstWhereOrNull((element) => element > 10);

      
      expect(result, null);
    });

    test('should return null when the list is empty', () {
      
      final list = <int>[];

      
      final result = list.firstWhereOrNull((element) => element > 0);

      
      expect(result, null);
    });

    test('should return the first occurrence when multiple elements match', () {
      
      final list = [1, 2, 3, 4, 5, 6];

      
      final result = list.firstWhereOrNull((element) => element % 2 == 0);

      
      expect(result, 2); // The first even number
    });

    test('should work with custom objects', () {
      
      final users = [
        User(id: 1, name: 'Alice'),
        User(id: 2, name: 'Bob'),
        User(id: 3, name: 'Charlie')
      ];

      
      final result =
          users.firstWhereOrNull((user) => user.name.startsWith('B'));

      
      expect(result?.name, 'Bob');
    });
  });
}

class User {
  final int id;
  final String name;

  User({required this.id, required this.name});
}
