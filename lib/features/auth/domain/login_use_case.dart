import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/auth/data/auth_repository.dart';
import 'package:style_me/features/auth/data/models/login_request.dart';
import 'package:style_me/features/auth/presentation/state/auth_state_holder.dart';

class LoginUseCase {
  final AuthRepository _repository;
  final NetworkRequestUtil _networkUtil;

  LoginUseCase(this._repository, this._networkUtil);

  Future<Result> call(AuthStateHolder state) {
    final LoginRequest loginRequest = LoginRequest.fromAuthState(state);
    return _networkUtil
        .makeRepositoryRequest(() => _repository.login(loginRequest));
  }
}
