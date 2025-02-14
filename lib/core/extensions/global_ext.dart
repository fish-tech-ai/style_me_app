import 'package:flutter/foundation.dart';

void debugMessagePrint(String message) {
  if (kDebugMode) {
    print(message);
  }
}
