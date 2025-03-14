import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:style_me/core/extensions/global_ext.dart';

class JsonErrorConverter extends JsonConverter {
  final Function errorConverter;

  const JsonErrorConverter(this.errorConverter);

  @override
  Future<Response> convertError<BodyType, InnerType>(Response response) async {
    try {
      final jsonBody = jsonDecode(response.bodyString);

      if (jsonBody is Map<String, dynamic> && jsonBody.containsKey('type')) {
        final errorObject = errorConverter(jsonBody);
        return response.copyWith<dynamic>(bodyError: errorObject);
      }

      return response.copyWith<BodyType>();
    } catch (e) {
      debugMessagePrint(e.toString());
      return response.copyWith<BodyType>();
    }
  }
}