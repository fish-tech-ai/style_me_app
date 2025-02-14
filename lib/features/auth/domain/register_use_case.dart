import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/auth/data/auth_repository.dart';
import 'package:style_me/features/auth/data/models/registration_request.dart';
import 'package:style_me/features/auth/presentation/state/auth_state_holder.dart';

class RegisterUseCase {
  final AuthRepository _repository;
  final NetworkRequestUtil _networkUtil;

  RegisterUseCase(this._repository, this._networkUtil);

  Future<Result> call(AuthStateHolder state) {
    final RegistrationRequest registrationRequest =
        RegistrationRequest.fromAuthState(state);
    return _networkUtil
        .makeRepositoryRequest(() => _repository.register(registrationRequest));
  }
}
