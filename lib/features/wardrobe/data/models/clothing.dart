import 'package:json_annotation/json_annotation.dart';
import 'package:style_me/features/wardrobe/data/models/clothing_category_enum.dart';
import 'package:style_me/features/wardrobe/data/models/clothing_position_enum.dart';
import 'package:style_me/features/wardrobe/data/models/photo_item.dart';
import 'package:style_me/features/wardrobe/presentation/ui_models/clothing_with_action.dart';

part 'clothing.g.dart';

@JsonSerializable()
class Clothing extends PhotoItem {
  final ClothingCategoryEnum category;
  final ClothingPositionEnum position;

  Clothing(String id, String name, String image, this.category, this.position)
      : super(id, image, name);

  factory Clothing.fromJson(Map<String, dynamic> json) {
    return _$ClothingFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ClothingToJson(this);

  ClothingWithAction withDeleteAction() {
    return ClothingWithAction.delete(this);
  }

  ClothingWithAction withUpdateAction() {
    return ClothingWithAction.update(this);
  }

  Clothing copyWith({
    String? id,
    String? name,
    String? image,
    ClothingCategoryEnum? category,
    ClothingPositionEnum? position,
  }) {
    return Clothing(
      id ?? this.id,
      name ?? this.name,
      image ?? this.image,
      category ?? this.category,
      position ?? this.position,
    );
  }
}
