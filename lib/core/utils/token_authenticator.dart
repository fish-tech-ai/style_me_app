import 'dart:async';

import 'package:style_me/core/app/domain/usecases/get_user_use_case.dart';
import 'package:style_me/core/app/domain/usecases/logout_user_use_case.dart';
import 'package:style_me/core/app/domain/usecases/refresh_token_use_case.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/core/extensions/global_ext.dart';
import 'package:style_me/core/extensions/string_ext.dart';
import 'package:style_me/core/local/database.dart';
import 'package:style_me/core/network/failures/failure.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/core/utils/google_auth_service.dart';

class TokenAuthenticator {
  TokenAuthenticator();

  Function(Failure) _onFailure = (failure) =>
      debugMessagePrint(failure.message ?? "Unknown error occured");

  void setFailureHandler(Function(Failure) onFailure) {
    _onFailure = onFailure;
  }

  Future<String?> refreshAndGetNewToken() async {
    final isAuthenticated = await authenticateUser();
    if (isAuthenticated) {
      final result = await _getUser();
      result.collect(
        (user) {
          return user.token;
        },
        (failure) {
          debugMessagePrint(failure.toString());
          return null;
        },
      );
    }
    return null;
  }

  Future<bool> authenticateUser() async {
    final Result<UserData> result = await _getUser();
    final completer = Completer<bool>();
    result.collect((user) async {
      if (user.token.isTokenExpired()) {
        completer.complete(await _refreshTokenIfValid(user.refreshToken));
      } else {
        completer.complete(true);
      }
    }, (failure) {
      completer.complete(false);
    });

    return completer.future;
  }

  Future<bool> _refreshTokenIfValid(String refreshToken) async {
    if (refreshToken.isTokenExpired()) {
      _logoutUser();
      return false;
    } else {
      return await _performTokenRefresh(refreshToken);
    }
  }

  Future<bool> _performTokenRefresh(String refreshToken) async {
    final Result result = await _refreshToken(refreshToken);
    final completer = Completer<bool>();
    result.collect((_) {
      completer.complete(true);
    }, (Failure failure) {
      _logoutUser();
      _onFailure(failure);
      completer.complete(false);
    });
    return completer.future;
  }

  void _logoutUser() {
    getIt<LogoutUserUseCase>().call();
    getIt<GoogleAuthService>().signOut();
  }

  Future<Result> _refreshToken(String refreshToken) =>
      getIt<RefreshTokenUseCase>().call(refreshToken);

  Future<Result<UserData>> _getUser() => getIt<GetUserUseCase>().call();
}
