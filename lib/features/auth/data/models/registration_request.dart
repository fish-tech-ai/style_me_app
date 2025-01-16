import 'package:json_annotation/json_annotation.dart';
import 'package:style_me/features/auth/presentation/state/auth_state_holder.dart';

part 'registration_request.g.dart';

@JsonSerializable()
class RegistrationRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  RegistrationRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  factory RegistrationRequest.fromJson(Map<String, dynamic> json) =>
      _$RegistrationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegistrationRequestToJson(this);

  factory RegistrationRequest.fromAuthState(AuthStateHolder state) {
    return RegistrationRequest(
      firstName: state.firstName.text,
      lastName: state.surname.text,
      email: state.email.text,
      password: state.password.text,
    );
  }
}
