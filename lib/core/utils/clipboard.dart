import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:super_clipboard/super_clipboard.dart';

class Clipboard {
  late final SystemClipboard systemClipboard;
  final List<SimpleFileFormat> supportedFormats = [
    Formats.jpeg,
    Formats.png,
    Formats.webp,
    Formats.bmp,
    Formats.heif,
  ];

  Clipboard() {
    /// system clipboard from super_clipboards are not available only on firefox, so this value will not be null
    systemClipboard = SystemClipboard.instance!;
  }

  Future<bool> containsImage(ClipboardReader reader) async {
    return supportedFormats.any(
      (supportedFormat) => reader.canProvide(supportedFormat),
    );
  }

  void fetchImageFile({
    required Function(File) onImageReceived,
    required Function() onNoImageInClipboard,
  }) async {
    final reader = await systemClipboard.read();
    if (await containsImage(reader)) {
      final format =
          reader.getFormats(supportedFormats).first as SimpleFileFormat;
      _fetchFileFromClipboard(reader, format, onImageReceived);
    } else {
      onNoImageInClipboard();
    }
  }

  void _fetchFileFromClipboard(ClipboardReader reader, SimpleFileFormat format,
      Function(File file) onFileReceived) {
    reader.getFile(format, (file) async {
      final stream = file.getStream();
      List<int> bytes = [];

      await for (final chunk in stream) {
        bytes.addAll(chunk);
      }

      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/clipboard_image.jpg';
      final fullFile = File(filePath);
      await fullFile.writeAsBytes(bytes, flush: true);

      onFileReceived(fullFile);
    });
  }
}
