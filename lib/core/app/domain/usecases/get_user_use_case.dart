import 'package:style_me/core/local/database.dart';
import 'package:style_me/core/network/failures/login_failure.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/auth/data/auth_repository.dart';

class GetUserUseCase {
  final AuthRepository repository;

  GetUserUseCase(this.repository);

  Future<Result<UserData>> call() async {
    final UserData? userData = await repository.getUser();
    if (userData == null) {
      return Result.fail(LoginFailure("No user is logged in"));
    }
    return Result.success(userData);
  }
}
