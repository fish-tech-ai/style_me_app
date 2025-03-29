import 'package:style_me/core/extensions/string_ext.dart';
import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/settings/data/models/delete_user_request.dart';
import 'package:style_me/features/settings/data/settings_repository.dart';

class DeleteAccountUseCase {
  final SettingsRepository _repository;
  final NetworkRequestUtil _networkUtil;

  DeleteAccountUseCase(this._repository, this._networkUtil);

  Future<Result> call(String password) {
    final DeleteUserRequest deleteAccountRequest =
        DeleteUserRequest(password.getHashed());
    return _networkUtil.makeRepositoryRequest(
        () => _repository.deleteAccount(deleteAccountRequest));
  }
}
