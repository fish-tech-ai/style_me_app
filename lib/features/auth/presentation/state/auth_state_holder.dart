import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state_holder.freezed.dart';

@freezed
class AuthStateHolder with _$AuthStateHolder {
  const factory AuthStateHolder({
    ///Text fields content
    @Default("") String firstName,
    @Default("") String surname,
    @Default("") String email,
    @Default("") String password,
    @Default("") String passwordVerify,

    ///Toggles
    @Default(false) bool isPasswordVisible,
    @Default(false) bool isPasswordVerifyVisible,
  }) = _AuthStateHolder;
}
