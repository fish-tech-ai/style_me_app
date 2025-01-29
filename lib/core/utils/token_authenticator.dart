import 'dart:async';

import 'package:style_me/core/app/domain/usecases/get_user_use_case.dart';
import 'package:style_me/core/app/domain/usecases/logout_user_use_case.dart';
import 'package:style_me/core/app/domain/usecases/refresh_token_use_case.dart';
import 'package:style_me/core/extensions/global_ext.dart';
import 'package:style_me/core/extensions/string_ext.dart';
import 'package:style_me/core/local/database.dart';
import 'package:style_me/core/network/failures/failure.dart';
import 'package:style_me/core/network/utils/result.dart';

class TokenAuthenticator {
  final GetUserUseCase _getUserUseCase;
  final LogoutUserUseCase _logoutUserUseCase;
  final RefreshTokenUseCase _refreshTokenUseCase;

  TokenAuthenticator(
    this._getUserUseCase,
    this._logoutUserUseCase,
    this._refreshTokenUseCase,
  );

  Function(Failure) _onFailure = (failure) =>
      debugMessagePrint(failure.message ?? "Unknown error occured");

  void setFailureHandler(Function(Failure) onFailure) {
    _onFailure = onFailure;
  }

  Future<bool> authenticateUser() async {
    final Result<UserData> result = await _getUserUseCase();
    final completer = Completer<bool>();
    result.collect((user) async {
      if (user.token.isTokenExpired()) {
        completer.complete(await refreshTokenIfValid(user.refreshToken));
      } else {
        completer.complete(true);
      }
    }, (failure) {
      completer.complete(false);
    });

    return completer.future;
  }

  Future<bool> refreshTokenIfValid(String refreshToken) async {
    if (refreshToken.isTokenExpired()) {
      _logoutUserUseCase();
      return false;
    } else {
      return await _performTokenRefresh(refreshToken);
    }
  }

  Future<bool> _performTokenRefresh(String refreshToken) async {
    final Result result = await _refreshTokenUseCase(refreshToken);
    final completer = Completer<bool>();
    result.collect((_) {
      completer.complete(true);
    }, (Failure failure) {
      _logoutUserUseCase();
      _onFailure(failure);
      completer.complete(false);
    });
    return completer.future;
  }
}
