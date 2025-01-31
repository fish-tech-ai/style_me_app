import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_response.g.dart';

@JsonSerializable()
class RefreshTokenResponse {
  final String accessToken;
  final String refreshToken;

  RefreshTokenResponse(this.refreshToken, this.accessToken);

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenResponseToJson(this);
}
