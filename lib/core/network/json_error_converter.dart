import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:style_me/core/extensions/global_ext.dart';

class JsonErrorConverter extends JsonConverter {
  final Function errorConverter;

  const JsonErrorConverter(this.errorConverter);

  @override
  Future<Response> convertError<BodyType, InnerType>(Response response) async {
    try {
      if (response.bodyString.isEmpty) {
        return response;
      }  
      
      final jsonBody = jsonDecode(response.bodyString);

      if (jsonBody is Map<String, dynamic> && jsonBody.containsKey('error')) {
        final errorObject = errorConverter(jsonBody);
        return response.copyWith<dynamic>(bodyError: errorObject);
      }

      return response;
    } catch (e) {
      debugMessagePrint(e.toString());
      return response.copyWith<BodyType>();
    }
  }
}