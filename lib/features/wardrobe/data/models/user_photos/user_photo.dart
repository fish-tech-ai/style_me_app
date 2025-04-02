import 'package:json_annotation/json_annotation.dart';
import 'package:style_me/features/wardrobe/data/models/photo_item.dart';

part 'user_photo.g.dart';

@JsonSerializable()
class UserPhoto extends PhotoItem {
  UserPhoto(super.id, super.image, super.name, {super.isDefault});

  factory UserPhoto.fromJson(Map<String, dynamic> json) {
    return _$UserPhotoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserPhotoToJson(this);
}