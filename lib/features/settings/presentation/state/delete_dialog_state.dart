import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_dialog_state.freezed.dart';

@freezed
sealed class DeleteDialogState with _$DeleteDialogState {
  const factory DeleteDialogState({
    @Default(false) bool isLoading,
    @Default(false) bool isPasswordVisible,
    @Default("") String password,
    String? errorMessage
  }) = _DeleteDialogState;
}