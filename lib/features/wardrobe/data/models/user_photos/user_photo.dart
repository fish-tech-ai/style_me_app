import 'package:json_annotation/json_annotation.dart';
import 'package:style_me/features/wardrobe/data/models/photo_item.dart';
import 'package:style_me/features/wardrobe/presentation/ui_models/photo_with_action.dart';

part 'user_photo.g.dart';

@JsonSerializable()
class UserPhoto extends PhotoItem {
  UserPhoto(super.id, super.image, super.name, {super.isDefault});

  PhotoWithAction withDeleteAction() {
    return PhotoWithAction.delete(this);
  }

  PhotoWithAction withUpdateAction() {
    return PhotoWithAction.update(this);
  }

  UserPhoto copyWith({
    String? id,
    String? name,
    String? image,
    bool? isDefault,
  }) {
    return UserPhoto(
      id ?? this.id,
      name ?? this.name,
      image ?? this.image,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  factory UserPhoto.fromJson(Map<String, dynamic> json) {
    return _$UserPhotoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserPhotoToJson(this);
}
