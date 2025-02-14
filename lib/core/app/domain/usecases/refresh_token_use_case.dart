import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/auth/data/auth_repository.dart';

class RefreshTokenUseCase {
  final AuthRepository repository;
  final NetworkRequestUtil _networkUtil;

  RefreshTokenUseCase(this.repository, this._networkUtil);

  Future<Result> call(String refreshToken) {
    return _networkUtil
        .makeRepositoryRequest(() => repository.refreshToken(refreshToken));
  }
}
