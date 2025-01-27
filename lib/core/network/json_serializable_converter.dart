import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';

class JsonSerializableConverter extends JsonConverter {
  final Map<Type, Function> typeToJsonFactory;

  const JsonSerializableConverter(this.typeToJsonFactory);

  @override
  Future<Response<ResultType>> convertResponse<ResultType, Item>(
      Response response) async {
    if (response.body.toString().isEmpty) {
      return response.copyWith();
    }

    final jsonBody = jsonDecode(response.body);
    final Function? fromJson = typeToJsonFactory[ResultType];

    if (fromJson == null || jsonBody == null) {
      if (kDebugMode) {
        debugPrint(
            "\x1b[31m$ResultType is not registered in lib/core/network/chopper_manager.dart\x1B[0m");
      }
      throw Exception('Cannot convert response to $ResultType');
    }

    final converted = fromJson(jsonBody) as ResultType;
    return response.copyWith<ResultType>(body: converted);
  }
}
