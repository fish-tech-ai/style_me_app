import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart';
import 'package:style_me/core/extensions/global_ext.dart';
import 'package:style_me/core/utils/constants.dart';

extension ImageTransformations on File {
  Future<File> getWithAspectRatio(double aspectRatio) async {
    Uint8List imageBytes = await readAsBytes();

    Image? originalImage = decodeImage(imageBytes);
    if (originalImage == null) return this;

    double previewAspectRatio = aspectRatio;

    int width = originalImage.width;
    int height = (width / previewAspectRatio).toInt();

    if (height > originalImage.height) {
      height = originalImage.height;
      width = (height * previewAspectRatio).toInt();
    }

    Image croppedImage = copyCrop(originalImage,
        x: (originalImage.width - width) ~/ 2,
        y: (originalImage.height - height) ~/ 2,
        width: width,
        height: height);

    return File(path)..writeAsBytesSync(encodeJpg(croppedImage));
  }

  Future<File> getFlippedHorizontally() async {
    try {
      Uint8List imageBytes = await readAsBytes();

      Image? originalImage = decodeImage(imageBytes);
      if (originalImage == null) throw Exception("Failed to decode image");

      Image flippedImage = flipHorizontal(originalImage);

      Uint8List flippedBytes = Uint8List.fromList(encodeJpg(flippedImage));

      File flippedFile = File(this.path);
      await flippedFile.writeAsBytes(flippedBytes);

      return flippedFile;
    } catch (e) {
      debugMessagePrint("Error flipping image: $e");
    }
    return this;
  }

  Future<File> getCompressed() async {
    try {
      final Uint8List imageBytes = await readAsBytes();
      Image? originalImage = decodeJpg(imageBytes);
      if (originalImage == null) throw Exception("Failed to decode image");
      final Image imageCompressed = copyResize(originalImage,
          height: ImageTransformationsOptions.compressedHeight);
      Uint8List compressedBytes = Uint8List.fromList(
        encodeJpg(imageCompressed,
            quality: ImageTransformationsOptions.compressedQuality),
      );

      File compressedFile = File(path);
      await compressedFile.writeAsBytes(compressedBytes);

      return compressedFile;
    } catch (e) {
      debugMessagePrint("Error while compressing: $e");
    }
    return this;
  }
}
