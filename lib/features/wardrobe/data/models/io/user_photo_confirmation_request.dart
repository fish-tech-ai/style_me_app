import 'package:json_annotation/json_annotation.dart';

part 'user_photo_confirmation_request.g.dart';

@JsonSerializable()
class UserPhotoConfirmationRequest {
  final String id;
  final String? name;
  final bool isDefault;
  final bool delete;

  UserPhotoConfirmationRequest(this.id, this.name, this.isDefault, this.delete);

  UserPhotoConfirmationRequest.add(this.id, this.name, this.isDefault)
      : delete = false;

  UserPhotoConfirmationRequest.delete(this.id)
      : name = null,
        isDefault = false,
        delete = true;

  factory UserPhotoConfirmationRequest.fromJson(Map<String, dynamic> json) {
    return _$UserPhotoConfirmationRequestFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserPhotoConfirmationRequestToJson(this);
}
