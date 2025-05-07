import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_position_enum.dart';

part 'generate_outfit_body.g.dart';

@JsonSerializable()
class GenerateOutfitBody {
  final String personImageId;
  final String? clothUpperImageId;
  final String? clothLowerImageId;
  final String? clothFullBodyImageId;

  GenerateOutfitBody(
    this.personImageId,
    this.clothUpperImageId,
    this.clothLowerImageId,
    this.clothFullBodyImageId,
  );

  factory GenerateOutfitBody.fromJson(Map<String, dynamic> json) {
    return _$GenerateOutfitBodyFromJson(json);
  }

  factory GenerateOutfitBody.from(
      String userImageId, List<Clothing> selectedClothes) {
    final clothingUpper = selectedClothes.firstWhereOrNull(
        (clothing) => clothing.position == ClothingPositionEnum.UPPER);
    final clothingLower = selectedClothes.firstWhereOrNull(
        (clothing) => clothing.position == ClothingPositionEnum.BOTTOM);
    final clothingFullBody = selectedClothes.firstWhereOrNull(
        (clothing) => clothing.position == ClothingPositionEnum.FULL_BODY);
    return GenerateOutfitBody(
      userImageId,
      clothingUpper?.id,
      clothingLower?.id,
      clothingFullBody?.id,
    );
  }

  Map<String, dynamic> toJson() => _$GenerateOutfitBodyToJson(this);
}
