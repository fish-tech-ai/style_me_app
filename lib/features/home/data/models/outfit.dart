import 'package:json_annotation/json_annotation.dart';
import 'package:style_me/features/wardrobe/data/models/photo_item.dart';

part 'outfit.g.dart';

@JsonSerializable()
class Outfit extends PhotoItem {

  @override
  @JsonKey(name: 'outfitId')
  String get id => super.id;

  @override
  @JsonKey(name: 'imageUrl')
  String get image => super.image;

  Outfit(super.id, super.image, super.name);

  factory Outfit.fromJson(Map<String, dynamic> json) {
    return _$OutfitFromJson(json);
  }

  Map<String, dynamic> toJson() => _$OutfitToJson(this);

  @override
  Outfit copyWith({String? id, String? name, String? image}) {
    return Outfit(id ?? this.id, name ?? this.name, image ?? this.image);
  }
}
