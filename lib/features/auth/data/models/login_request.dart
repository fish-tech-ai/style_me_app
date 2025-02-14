import 'package:json_annotation/json_annotation.dart';
import 'package:style_me/core/extensions/string_ext.dart';
import 'package:style_me/features/auth/presentation/state/auth_state_holder.dart';

part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  factory LoginRequest.fromAuthState(AuthStateHolder state) => LoginRequest(
      email: state.email.text, password: state.password.text.getHashed());

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
