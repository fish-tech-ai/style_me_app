import 'package:json_annotation/json_annotation.dart';
import 'package:style_me/features/wardrobe/data/models/clothing_category_enum.dart';
import 'package:style_me/features/wardrobe/data/models/clothing_position_enum.dart';
import 'package:style_me/features/wardrobe/data/models/photo_item.dart';

part 'clothing.g.dart';

@JsonSerializable()
class Clothing extends PhotoItem {
  final String id;
  final String name;
  final String image;
  final ClothingCategoryEnum category;
  final ClothingPositionEnum position;

  Clothing(this.id, this.name, this.image, this.category, this.position)
      : super(id, image, name);

  factory Clothing.fromJson(Map<String, dynamic> json) {
    return _$ClothingFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ClothingToJson(this);
}
