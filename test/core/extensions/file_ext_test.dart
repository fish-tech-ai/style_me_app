import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:style_me/core/extensions/file_ext.dart';

void main() {
  late Directory tempDir;
  late File sampleImageFile;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('image_test');
    final image = img.Image(width: 100, height: 100);
    img.fill(image, color: img.ColorFloat64.rgb(255, 0, 0));
    final jpg = img.encodeJpg(image);

    sampleImageFile = File(p.join(tempDir.path, 'test_image.webp'));
    await sampleImageFile.writeAsBytes(jpg);
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  test('getWithAspectRatio returns image with specified aspect ratio',
      () async {
    final result = await sampleImageFile.getWithAspectRatio(16 / 9);

    expect(result.existsSync(), true);
    final img.Image? croppedImage = img.decodeImage(await result.readAsBytes());

    expect(croppedImage, isNotNull);
    final actualAspectRatio = croppedImage!.width / croppedImage.height;
    expect((actualAspectRatio - (16 / 9)).abs() < 0.1, true);
  });

  test('getFlippedHorizontally returns a flipped image', () async {
    final result = await sampleImageFile.getFlippedHorizontally();

    expect(result.existsSync(), true);
    final img.Image? flippedImage = img.decodeImage(await result.readAsBytes());

    expect(flippedImage, isNotNull);
  });

  test('getCompressed returns a compressed file in .webp format', () async {
    final result = await sampleImageFile.getCompressed();

    expect(result.existsSync(), true);
    expect(p.extension(result.path), '.webp');
  });
}
