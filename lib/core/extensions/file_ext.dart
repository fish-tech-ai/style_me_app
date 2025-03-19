import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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
      Uint8List imageBytes = await readAsBytes();
      Image? image = decodeImage(imageBytes);
      if (image == null) {
        throw CompressError("Failed to decode image from file_ext.dart: getCompressed()");
      }
      int newWidth = 600;
      int newHeight = (image.height * newWidth / image.width).round();

      Uint8List? compressedBytes = await FlutterImageCompress.compressWithFile(
        path,
        quality: 90,
        minWidth: newWidth,
        minHeight: newHeight,
        format: CompressFormat.webp,
        keepExif: true
      );

      if (compressedBytes == null) {
        throw CompressError("compressedBytes = null from file_ext.dart: getCompressed()");
      }

      String newPath = path.replaceAll(RegexConst.fileExtension, '.webp');
      File compressedFile = File(newPath);
      await compressedFile.writeAsBytes(compressedBytes);

      return compressedFile;
    } catch (e) {
      debugMessagePrint("Error while compressing: $e");
    }
    return this;
  }
}
