import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:style_me/core/extensions/response_ext.dart';
import 'package:style_me/core/extensions/string_ext.dart';
import 'package:style_me/core/network/exceptions/server_exception.dart';
import 'package:style_me/core/network/services/app_service.dart';
import 'package:style_me/core/network/services/user_service.dart';
import 'package:style_me/features/auth/data/models/reset_password_request.dart';
import 'package:style_me/features/settings/data/models/delete_user_request.dart';
import 'package:style_me/features/settings/data/models/report_request.dart';

class SettingsRepository {
  final UserService service;
  final AppService appService;

  SettingsRepository(this.service, this.appService);

  Future resetPassword(
      ResetPasswordRequest resetPasswordRequest, String? token) async {
    final Response response =
        await service.resetPassword(resetPasswordRequest, token?.withBearer());
    if (response.statusCode == HttpStatus.notAcceptable) {
      throw ServerException("", HttpStatus.notAcceptable);
    }
    response.handleIfNotSuccessful();
  }

  Future deleteAccount(DeleteUserRequest deleteUserRequest) async {
    final Response response = await service.deleteAccount(deleteUserRequest);
    if (response.statusCode == HttpStatus.forbidden) {
      throw ServerException("", HttpStatus.forbidden);
    }
    response.handleIfNotSuccessful();
  }

  Future addReport(ReportRequest request) async {
    final Response response = await appService.addReport(request);
    response.handleIfNotSuccessful();
  }
}
