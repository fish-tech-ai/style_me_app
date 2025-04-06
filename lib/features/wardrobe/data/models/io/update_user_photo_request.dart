import 'package:json_annotation/json_annotation.dart';

part 'update_user_photo_request.g.dart';

@JsonSerializable()
class UpdateUserPhotoRequest {
  final String name;
  final bool isDefault;

  UpdateUserPhotoRequest(this.name, this.isDefault);

  factory UpdateUserPhotoRequest.fromJson(Map<String, dynamic> json) {
    return _$UpdateUserPhotoRequestFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UpdateUserPhotoRequestToJson(this);
}
