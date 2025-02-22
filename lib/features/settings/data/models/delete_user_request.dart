import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_user_request.g.dart';

@JsonSerializable()
class DeleteUserRequest {
  final String password;

  DeleteUserRequest(this.password);

  factory DeleteUserRequest.fromJson(Map<String, dynamic> json) =>
      _$DeleteUserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteUserRequestToJson(this);
}
