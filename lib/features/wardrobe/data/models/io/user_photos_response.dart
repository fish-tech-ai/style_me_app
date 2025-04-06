import 'package:json_annotation/json_annotation.dart';
import 'package:style_me/features/wardrobe/data/models/user_photos/user_photo.dart';

part 'user_photos_response.g.dart';

@JsonSerializable()
class UserPhotosResponse {
  final List<UserPhoto> data;

  UserPhotosResponse(this.data);

  factory UserPhotosResponse.fromJson(Map<String, dynamic> json) {
    return _$UserPhotosResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserPhotosResponseToJson(this);
}
