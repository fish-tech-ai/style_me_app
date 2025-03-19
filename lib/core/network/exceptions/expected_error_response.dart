import 'package:json_annotation/json_annotation.dart';
import 'package:style_me/core/network/exceptions/helpers/image_error_type/image_type_enum.dart';

part 'expected_error_response.g.dart';

@JsonSerializable()
class ExpectedErrorResponse {
  final ImageErrorTypeEnum type;

  ExpectedErrorResponse(this.type);

  factory ExpectedErrorResponse.fromJson(Map<String, dynamic> json) {
    return _$ExpectedErrorResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ExpectedErrorResponseToJson(this);
}