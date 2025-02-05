import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:style_me/core/utils/constants.dart';
import 'package:style_me/core/utils/token_authenticator.dart';

class AppAuthenticator implements Authenticator {
  final TokenAuthenticator _tokenAuthenticator;

  AppAuthenticator(this._tokenAuthenticator);

  @override
  FutureOr<Request?> authenticate(Request request, Response<dynamic> response,
      [Request? originalRequest]) async {
    if (response.statusCode == 401) {
      final newToken = await _tokenAuthenticator.refreshAndGetNewToken();
      if (newToken == null) {
        return null;
      }
      return request.copyWith(headers: {
        ...request.headers,
        NetworkHeaders.authorization: 'Bearer $newToken',
      });
    }
    return null;
  }

  @override
  AuthenticationCallback? get onAuthenticationFailed => null;

  @override
  AuthenticationCallback? get onAuthenticationSuccessful => null;
}
