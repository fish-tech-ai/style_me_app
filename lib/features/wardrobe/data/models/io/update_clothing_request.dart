import 'package:json_annotation/json_annotation.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_category_enum.dart';

part 'update_clothing_request.g.dart';

@JsonSerializable()
class UpdateClothingRequest {
  final String name;
  final ClothingCategoryEnum category;

  UpdateClothingRequest(this.name, this.category);

  factory UpdateClothingRequest.fromJson(Map<String, dynamic> json) {
    return _$UpdateClothingRequestFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UpdateClothingRequestToJson(this);
}
