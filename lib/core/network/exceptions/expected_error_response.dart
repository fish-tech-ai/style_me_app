import 'package:json_annotation/json_annotation.dart';
import 'package:style_me/core/network/exceptions/helpers/error_type_enum.dart';

part 'expected_error_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ExpectedErrorResponse {
  final ErrorTypeEnum type;

  ExpectedErrorResponse(this.type);

  factory ExpectedErrorResponse.fromJson(Map<String, dynamic> json) {
    return _$ExpectedErrorResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ExpectedErrorResponseToJson(this);
}