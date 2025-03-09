import 'package:json_annotation/json_annotation.dart';

part 'photo_item.g.dart';

@JsonSerializable()
class PhotoItem {
  final String imageId;
  final String imageUrl;
  final String imageName;
  final bool isDefault;

  PhotoItem(this.imageId, this.imageUrl, this.imageName, {this.isDefault = false});

  factory PhotoItem.fromJson(Map<String, dynamic> json) {
    return _$PhotoItemFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PhotoItemToJson(this);
}
