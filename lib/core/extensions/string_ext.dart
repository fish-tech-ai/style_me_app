import 'dart:convert';

import 'package:crypto/crypto.dart';

extension Cryptography on String {
  String getHashed() {
    final bytes = utf8.encode(this);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}