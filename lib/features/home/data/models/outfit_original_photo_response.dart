import 'package:freezed_annotation/freezed_annotation.dart';

part 'outfit_original_photo_response.g.dart';

@JsonSerializable()
class OutfitOriginalPhotoResponse {
  @JsonKey(name: "SingleOutfitUrl")
  final String originalOutfitUrl;

  OutfitOriginalPhotoResponse(this.originalOutfitUrl);

  factory OutfitOriginalPhotoResponse.fromJson(Map<String, dynamic> json) {
    return _$OutfitOriginalPhotoResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$OutfitOriginalPhotoResponseToJson(this);
}
