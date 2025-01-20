import 'package:drift/drift.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:style_me/core/local/database.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final String email;
  final String firstName;
  final String accessToken;
  final String refreshToken;

  LoginResponse(
    this.email,
    this.firstName,
    this.accessToken,
    this.refreshToken,
  );

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);

  UserCompanion toUserTable() {
    return UserCompanion(
      name: Value(firstName),
      email: Value(email),
      token: Value(accessToken),
      refreshToken: Value(refreshToken),
    );
  }
}
