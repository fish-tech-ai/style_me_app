import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/auth/data/auth_repository.dart';
import 'package:style_me/features/auth/data/models/reset_password_request.dart';

class ChangePasswordUseCase {
  final AuthRepository _repository;
  final NetworkRequestUtil _networkUtil;

  ChangePasswordUseCase(this._repository, this._networkUtil);

  Future<Result> call(String token, String newPassword) {
    final ResetPasswordRequest resetPasswordRequest =
        ResetPasswordRequest(newPassword: newPassword);
    return _networkUtil.makeRepositoryRequest(
        () => _repository.resetPassword(resetPasswordRequest, token));
  }
}
