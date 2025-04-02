import 'package:json_annotation/json_annotation.dart';

part 'send_user_photo_response.g.dart';

@JsonSerializable()
class SendUserPhotoResponse {
  final String id;

  SendUserPhotoResponse(this.id);

  factory SendUserPhotoResponse.fromJson(Map<String, dynamic> json) {
    return _$SendUserPhotoResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SendUserPhotoResponseToJson(this);
}