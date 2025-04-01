import 'package:json_annotation/json_annotation.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_category_enum.dart';

part 'clothing_confirmation_request.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ClothingConfirmationRequest {
  final String id;
  final String? name;
  final ClothingCategoryEnum category;
  final bool delete;

  ClothingConfirmationRequest(this.id, this.name, this.category, this.delete);

  ClothingConfirmationRequest.add(this.id, this.name, this.category)
      : delete = false;

  ClothingConfirmationRequest.delete(this.id)
      : name = null,
        category = ClothingCategoryEnum.BLAZER,
        delete = true;

  factory ClothingConfirmationRequest.fromJson(Map<String, dynamic> json) {
    return _$ClothingConfirmationRequestFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ClothingConfirmationRequestToJson(this);
}
