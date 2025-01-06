import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:style_me/features/auth/presentation/state/auth_state_holder.dart';

part 'auth_view_model.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  @override
  AuthStateHolder build() {
    return AuthStateHolder();
  }

  void updateTextInput({
    String? firstName,
    String? surname,
    String? email,
    String? password,
    String? passwordVerify,
  }) {
    state = state.copyWith(
      firstName: firstName ?? state.firstName,
      surname: surname ?? state.surname,
      email: email ?? state.email,
      password: password ?? state.password,
      passwordVerify: passwordVerify ?? state.passwordVerify,
    );
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void togglePasswordVerifyVisibility() {
    state =
        state.copyWith(isPasswordVerifyVisible: !state.isPasswordVerifyVisible);
  }
}
