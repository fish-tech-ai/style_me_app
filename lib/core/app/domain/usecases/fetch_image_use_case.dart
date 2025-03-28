import 'dart:typed_data';

import 'package:style_me/core/extensions/global_ext.dart';
import 'package:http/http.dart' as http;

class FetchImageUseCase {
  FetchImageUseCase();

  Future<Uint8List> call(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception("${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      debugMessagePrint("Failed to load image: $e");
      throw Exception("Failed to load image");
    }
  }
}
