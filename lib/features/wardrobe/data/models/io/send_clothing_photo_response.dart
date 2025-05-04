import 'package:json_annotation/json_annotation.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_category_enum.dart';

part 'send_clothing_photo_response.g.dart';

@JsonSerializable()
class SendClothingPhotoResponse {
  final String id;
  final ClothingCategoryEnum recommendedCategory;

  SendClothingPhotoResponse(this.id, this.recommendedCategory);

  factory SendClothingPhotoResponse.fromJson(Map<String, dynamic> json) {
    return _$SendClothingPhotoResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SendClothingPhotoResponseToJson(this);
}
