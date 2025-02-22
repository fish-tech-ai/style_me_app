import 'package:style_me/core/utils/google_auth_service.dart';
import 'package:style_me/features/auth/data/auth_repository.dart';

class LogoutUserUseCase {
  final AuthRepository repository;
  final GoogleAuthService googleAuthService;

  LogoutUserUseCase(this.repository, this.googleAuthService);

  Future call() async {
    googleAuthService.signOut();
    await repository.logoutUser();
  }
}