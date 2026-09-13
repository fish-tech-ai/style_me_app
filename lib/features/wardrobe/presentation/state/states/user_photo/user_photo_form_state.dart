import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_photo_form_state.freezed.dart';

@freezed
sealed class UserPhotoFormState with _$UserPhotoFormState {
  const factory UserPhotoFormState({
    @Default("") String nameText,
    @Default(false) bool isDefault
  }) = _UserPhotoFormState;
}