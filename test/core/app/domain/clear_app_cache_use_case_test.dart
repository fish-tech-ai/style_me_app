import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:style_me/core/app/domain/usecases/clear_app_cache_use_case.dart';
import 'package:style_me/core/extensions/global_ext.dart';

void main() {
  late ClearAppCacheUseCase useCase;

  setUp(() {
    useCase = ClearAppCacheUseCase();
  });

  test('does nothing if directory does not exist', () async {
    final nonExistentPath = '${Directory.systemTemp.path}/does_not_exist_123';

    // Just make sure it doesn't throw
    await useCase(nonExistentPath);
  });

  test('deletes files in existing directory', () async {
    final tempDir = await Directory.systemTemp.createTemp('cache_test_');
    final file1 = File('${tempDir.path}/file1.txt');
    final file2 = File('${tempDir.path}/file2.txt');
    await file1.writeAsString('test');
    await file2.writeAsString('test');

    expect(await file1.exists(), isTrue);
    expect(await file2.exists(), isTrue);

    await useCase(tempDir.path);

    expect(await file1.exists(), isFalse);
    expect(await file2.exists(), isFalse);
    expect(await tempDir.exists(), isTrue); // Folder remains
  });

  test('handles deletion errors gracefully', () async {
    final tempDir = await Directory.systemTemp.createTemp('cache_test_');
    final file = File('${tempDir.path}/readonly.txt');
    await file.writeAsString('locked');

    await file.setReadOnly();

    await useCase(tempDir.path);

    if (await file.exists()) {
      await file.setWritable();
      await file.delete();
    }
    await tempDir.delete();
  });
}

extension on File {
  Future<void> setReadOnly() async {
    await setPermissions(false);
  }

  Future<void> setWritable() async {
    await setPermissions(true);
  }

  Future<void> setPermissions(bool writable) async {
    final result = await Process.run('chmod', [writable ? '644' : '444', path]);
    if (result.exitCode != 0) {
      debugMessagePrint('chmod failed: ${result.stderr}');
    }
  }
}
