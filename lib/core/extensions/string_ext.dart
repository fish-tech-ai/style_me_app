import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:style_me/core/extensions/global_ext.dart';

extension Cryptography on String {
  String getHashed() {
    final bytes = utf8.encode(this);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  bool isTokenExpired() {
    try {
      final List<String> parts = split('.');
      if (parts.length != 3) {
        debugMessagePrint('Invalid JWT token');
      }

      final String payload =
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final payloadMap = json.decode(payload);

      final exp = payloadMap['exp'];

      if (exp != null) {
        final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
        return DateTime.now().isAfter(expiryDate);
      } else {
        return true;
      }
    } catch (e) {
      debugMessagePrint("Error decoding JWT: $e");
      return true;
    }
  }
}
