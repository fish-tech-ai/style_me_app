import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/auth/data/auth_repository.dart';
import 'package:style_me/features/auth/data/models/email_state_enum.dart';

class CheckEmailUseCase {
  final AuthRepository _repository;
  final NetworkRequestUtil _networkUtil;

  CheckEmailUseCase(this._repository, this._networkUtil);

  Future<Result<EmailStateEnum>> call(String email) {
    return _networkUtil
        .makeRepositoryRequest(() => _repository.checkEmail(email));
  }
}
