import 'package:style_me/features/auth/data/auth_repository.dart';

class LogoutUserUseCase {
  final AuthRepository repository;

  LogoutUserUseCase(this.repository);

  Future call() async {
    await repository.logoutUser();
  }
}