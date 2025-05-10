import 'package:json_annotation/json_annotation.dart';

part 'generated_outfit_response.g.dart';

@JsonSerializable()
class GeneratedOutfitResponse {
  final String outfitId;
  final String imageUrl;

  GeneratedOutfitResponse(this.outfitId, this.imageUrl);

  factory GeneratedOutfitResponse.fromJson(Map<String, dynamic> json) {
    return _$GeneratedOutfitResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$GeneratedOutfitResponseToJson(this);
}
