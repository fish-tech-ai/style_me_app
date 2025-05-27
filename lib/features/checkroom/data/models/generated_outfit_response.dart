import 'package:json_annotation/json_annotation.dart';

part 'generated_outfit_response.g.dart';

@JsonSerializable()
class GeneratedOutfitResponse {
  final String id;
  final String image;

  GeneratedOutfitResponse(this.id, this.image);

  factory GeneratedOutfitResponse.fromJson(Map<String, dynamic> json) {
    return _$GeneratedOutfitResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$GeneratedOutfitResponseToJson(this);
}
