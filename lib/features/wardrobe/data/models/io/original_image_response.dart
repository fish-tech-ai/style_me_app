import 'package:json_annotation/json_annotation.dart';

part 'original_image_response.g.dart';

@JsonSerializable()
class OriginalImageUrlResponse {
  final String signedUrl;

  OriginalImageUrlResponse(this.signedUrl);

  factory OriginalImageUrlResponse.fromJson(Map<String, dynamic> json) {
    return _$OriginalImageUrlResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$OriginalImageUrlResponseToJson(this);
}