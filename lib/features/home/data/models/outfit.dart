import 'package:json_annotation/json_annotation.dart';
import 'package:style_me/features/wardrobe/data/models/photo_item.dart';

part 'outfit.g.dart';

@JsonSerializable()
class Outfit extends PhotoItem {
  Outfit(
    super.id,
    super.image,
    super.name, {
    super.isFavorite,
  });

  factory Outfit.fromJson(Map<String, dynamic> json) {
    return _$OutfitFromJson(json);
  }

  Map<String, dynamic> toJson() => _$OutfitToJson(this);

  @override
  Outfit copyWith({
    String? id,
    String? name,
    String? image,
    bool? isFavorite,
  }) {
    return Outfit(
      id ?? this.id,
      image ?? this.image,
      name ?? this.name,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
