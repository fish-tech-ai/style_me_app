import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:style_me/core/extensions/global_ext.dart';

class JsonSerializableConverter extends JsonConverter {
  final Map<Type, Function> typeToJsonFactory;
  final Function errorConverter;

  const JsonSerializableConverter(this.typeToJsonFactory, this.errorConverter);

  @override
  Future<Response<ResultType>> convertResponse<ResultType, Item>(
      Response response) async {
    if (response.body.toString().isEmpty) {
      return response.copyWith();
    }

    final jsonBody = jsonDecode(response.body);
    final Function? fromJson = typeToJsonFactory[ResultType];

    if (fromJson == null || jsonBody == null) {
      debugMessagePrint(
          "\x1b[31m$ResultType is not registered in lib/core/network/chopper_manager.dart\x1B[0m");
      throw Exception('Cannot convert response to $ResultType');
    }

    final converted = fromJson(jsonBody) as ResultType;
    return response.copyWith<ResultType>(body: converted);
  }

  @override
  Future<Response> convertError<BodyType, InnerType>(Response response) async {
    try {
      final jsonBody = jsonDecode(response.body);

      if (jsonBody is Map<String, dynamic> && jsonBody.containsKey('type')) {
        final errorObject = errorConverter(jsonBody);
        return response.copyWith<BodyType>(bodyError: errorObject);
      }

      return response;
    } catch (e) {
      debugMessagePrint(e.toString());
      return response;
    }
  }
}
