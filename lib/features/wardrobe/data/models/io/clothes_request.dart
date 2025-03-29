import 'package:json_annotation/json_annotation.dart';

part 'clothes_request.g.dart';

@JsonSerializable()
class ClothesRequest {
  final String? searchText;
  final String? position;
  final String? category;

  ClothesRequest(this.searchText, this.position, this.category);

  factory ClothesRequest.fromJson(Map<String, dynamic> json) {
    return _$ClothesRequestFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ClothesRequestToJson(this);
}
