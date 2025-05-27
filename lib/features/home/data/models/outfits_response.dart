import 'package:json_annotation/json_annotation.dart';
import 'package:style_me/features/home/data/models/outfit.dart';

part 'outfits_response.g.dart';

@JsonSerializable()
class OutfitsResponse {
  final List<Outfit> data;

  OutfitsResponse(this.data);

  factory OutfitsResponse.fromJson(Map<String, dynamic> json) {
    return _$OutfitsResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$OutfitsResponseToJson(this);
}