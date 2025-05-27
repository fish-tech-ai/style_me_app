import 'dart:io';

import 'package:style_me/core/extensions/global_ext.dart';

class ClearAppCacheUseCase {
  ClearAppCacheUseCase();

  Future call(String path) async {
    final dir = Directory(path);
    if (!await dir.exists()) {
      debugMessagePrint('Directory does not exist: $path');
      return;
    }

    await for (var entity in dir.list(recursive: false, followLinks: false)) {
      if (entity is File) {
        try {
          await entity.delete();
        } catch (e) {
          debugMessagePrint('Error deleting file ${entity.path}: $e');
        }
      }
    }
  }
}
