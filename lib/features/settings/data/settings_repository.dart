import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:style_me/core/extensions/response_ext.dart';
import 'package:style_me/core/extensions/string_ext.dart';
import 'package:style_me/core/network/exceptions/server_exception.dart';
import 'package:style_me/core/network/services/user_service.dart';
import 'package:style_me/features/auth/data/models/reset_password_request.dart';
import 'package:style_me/features/settings/data/models/delete_user_request.dart';

class SettingsRepository {
  final UserService service;

  SettingsRepository(this.service);

  Future resetPassword(
      ResetPasswordRequest resetPasswordRequest, String? token) async {
    final Response response =
        await service.resetPassword(resetPasswordRequest, token?.withBearer());
    if (response.statusCode == HttpStatus.notAcceptable) {
      throw ServerException("", HttpStatus.notAcceptable);
    }
    response.handleIfNotSuccessful();
  }

  Future deleteAccount(
      DeleteUserRequest resetUserRequest) async {
    final Response response =
    await service.deleteAccount(resetUserRequest);
    if (response.statusCode == HttpStatus.forbidden) {
      throw ServerException("", HttpStatus.forbidden);
    }
    response.handleIfNotSuccessful();
  }
}
