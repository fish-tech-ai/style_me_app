import 'package:json_annotation/json_annotation.dart';
import 'package:style_me/features/wardrobe/data/models/clothing.dart';

part 'clothes_response.g.dart';

@JsonSerializable()
class ClothesResponse {
  final List<Clothing> data;

  ClothesResponse(this.data);

  factory ClothesResponse.fromJson(Map<String, dynamic> json) {
    return _$ClothesResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ClothesResponseToJson(this);
}
