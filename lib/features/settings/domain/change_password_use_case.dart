import 'package:style_me/core/extensions/string_ext.dart';
import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/auth/data/models/reset_password_request.dart';
import 'package:style_me/features/settings/data/settings_repository.dart';

class ChangePasswordUseCase {
  final SettingsRepository _repository;
  final NetworkRequestUtil _networkUtil;

  ChangePasswordUseCase(this._repository, this._networkUtil);

  Future<Result> call(String? token, String newPassword, String? oldPassword) {
    final ResetPasswordRequest resetPasswordRequest =
        ResetPasswordRequest(oldPassword.getHashed(), newPassword.getHashed());
    return _networkUtil.makeRepositoryRequest(
        () => _repository.resetPassword(resetPasswordRequest, token));
  }
}
