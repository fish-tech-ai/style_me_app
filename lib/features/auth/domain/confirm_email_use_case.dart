import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/auth/data/auth_repository.dart';

class ConfirmEmailUseCase {
  final AuthRepository _repository;
  final NetworkRequestUtil _networkUtil;

  ConfirmEmailUseCase(this._repository, this._networkUtil);

  Future<Result> call(String token) {
    return _networkUtil
        .makeRepositoryRequest(() => _repository.confirmEmail(token));
  }
}
