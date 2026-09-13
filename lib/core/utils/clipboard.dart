import 'dart:io';

import 'package:collection/collection.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:path_provider/path_provider.dart';

class Clipboard {
  final List<String> supportedExtensions = [
    '.jpg',
    '.jpeg',
    '.png',
    '.webp',
    '.bmp',
    '.heif'
  ];

  Clipboard();

  Future<bool> containsImage() async {
    final imageBytes = await Pasteboard.image;
    if (imageBytes != null) return true;

    final files = await Pasteboard.files();
    return files.any((path) {
      final lowerPath = path.toLowerCase();
      return supportedExtensions.any((ext) => lowerPath.endsWith(ext));
    });
  }

  Future<void> fetchImageFile({
    required Function(File) onImageReceived,
    required Function() onNoImageInClipboard,
  }) async {
    final imageBytes = await Pasteboard.image;
    if (imageBytes != null) {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/clipboard_image.jpg');
      await file.writeAsBytes(imageBytes, flush: true);
      onImageReceived(file);
      return;
    }

    final files = await Pasteboard.files();
    if (files.isNotEmpty) {
      final imagePath = files.firstWhereOrNull((path) {
        final lowerPath = path.toLowerCase();
        return supportedExtensions.any((ext) => lowerPath.endsWith(ext));
      });

      if (imagePath != null) {
        onImageReceived(File(imagePath));
        return;
      }
    }

    onNoImageInClipboard();
  }
}