import 'package:chopper/chopper.dart';

class JsonSerializableConverter extends JsonConverter {
  final Map<Type, Function> typeToJsonFactory;

  const JsonSerializableConverter(this.typeToJsonFactory);

  @override
  Future<Response<ResultType>> convertResponse<ResultType, Item>(
      Response response) async {
    final jsonResponse = await super.convertResponse<String, dynamic>(response);

    final jsonBody = jsonResponse.body;
    final Function? fromJson = typeToJsonFactory[ResultType];

    if (fromJson == null || jsonBody == null) {
      throw Exception('Cannot convert response to $ResultType');
    }

    final converted = fromJson(jsonBody) as ResultType;

    return jsonResponse.copyWith<ResultType>(body: converted);
  }
}
