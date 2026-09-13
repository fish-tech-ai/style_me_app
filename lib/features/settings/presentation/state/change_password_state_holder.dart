import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:style_me/features/auth/presentation/ui_models/text_field_state.dart';

part 'change_password_state_holder.freezed.dart';

@freezed
sealed class ChangePasswordStateHolder with _$ChangePasswordStateHolder {
  const factory ChangePasswordStateHolder({
    @Default(TextFieldState()) TextFieldState oldPassword,
    @Default(TextFieldState()) TextFieldState newPassword,
    @Default(TextFieldState()) TextFieldState verifyPassword,
    @Default(false) bool isAllValidated,
    @Default(false) bool isLoading
  }) = _ChangePasswordStateHolder;
}
