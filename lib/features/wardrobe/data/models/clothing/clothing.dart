import 'package:json_annotation/json_annotation.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_category_enum.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_position_enum.dart';
import 'package:style_me/features/wardrobe/data/models/photo_item.dart';

part 'clothing.g.dart';

@JsonSerializable()
class Clothing extends PhotoItem {
  final ClothingCategoryEnum category;
  final ClothingPositionEnum position;

  Clothing(
    String id,
    String name,
    String image,
    this.category,
    this.position, {
    bool isSelected = false,
    bool isDisabled = false,
  }) : super(id, image, name);

  factory Clothing.fromJson(Map<String, dynamic> json) {
    return _$ClothingFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ClothingToJson(this);

  @override
  Clothing copyWith({
    String? id,
    String? name,
    String? image,
    ClothingCategoryEnum? category,
    ClothingPositionEnum? position,
    bool? isSelected,
    bool? isDisabled,
  }) {
    return Clothing(
      id ?? this.id,
      name ?? this.name,
      image ?? this.image,
      category ?? this.category,
      position ?? this.position,
      isSelected: isSelected ?? this.isSelected,
      isDisabled: isDisabled ?? this.isDisabled,
    );
  }
}
