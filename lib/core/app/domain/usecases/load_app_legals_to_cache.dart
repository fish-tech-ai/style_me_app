import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:style_me/core/extensions/global_ext.dart';
import 'package:style_me/core/utils/constants.dart';

/// this use case can block main isolate, use only from static pages like splash screen
class LoadAppLegalsToCache {
  LoadAppLegalsToCache();

  Future call() async {
    final cacheDir = await getTemporaryDirectory();
    final privacyFile =
        File('${cacheDir.path}/${CacheFileNames.privacyPolicy}');
    final termsFile = File('${cacheDir.path}/${CacheFileNames.termsOfUse}');

    if (!await privacyFile.exists() || !await termsFile.exists()) {
      final privacyPolicy =
          await rootBundle.loadString('assets/privacy_policy.md');
      final termsOfUse = await rootBundle.loadString('assets/terms_of_use.md');

      await privacyFile.writeAsString(privacyPolicy);
      await termsFile.writeAsString(termsOfUse);
      debugMessagePrint("Legal documents has been cached");
    }
  }
}
