import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:style_me/core/extensions/list_ext.dart';
import 'package:style_me/core/extensions/response_ext.dart';
import 'package:style_me/core/extensions/string_ext.dart';
import 'package:style_me/core/local/database.dart';
import 'package:style_me/core/network/exceptions/server_exception.dart';
import 'package:style_me/core/network/services/auth_service.dart';
import 'package:style_me/features/auth/data/models/email_state_enum.dart';
import 'package:style_me/features/auth/data/models/login_request.dart';
import 'package:style_me/features/auth/data/models/refresh_token_request.dart';
import 'package:style_me/features/auth/data/models/refresh_token_response.dart';
import 'package:style_me/features/auth/data/models/registration_request.dart';
import 'package:style_me/features/auth/data/models/login_response.dart';

class AuthRepository {
  final AuthService service;
  final AppDatabase database;

  AuthRepository(this.service, this.database);

  Future<EmailStateEnum> checkEmail(String email) async {
    try {
      final response = await service.checkEmail(email);
      final EmailStateEnum? emailState = EmailStateEnum.values.firstWhereOrNull(
          (emailState) => emailState.code == response.statusCode);
      if (emailState == null) {
        throw ServerException(response.error.toString());
      } else {
        return emailState;
      }
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  Future confirmEmail(String token) async {
    try {
      final Response response = await service.confirmEmail(token.withBearer());
      response.handleIfNotSuccessful();
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  Future resendConfirmation(String email) async {
    try {
      final Response response = await service.resendConfirmation(email);
      response.handleIfNotSuccessful();
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  Future<LoginResponse> login(LoginRequest loginRequest) async {
    try {
      final response = await service.login(loginRequest);
      if (response.statusCode == HttpStatus.unauthorized) {
        throw ServerException(HttpStatus.unauthorized.toString());
      }
      response.handleIfNotSuccessful();
      _saveUser(response.body!);
      return response.body!;
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  Future<LoginResponse> loginWithGoogle(String token) async {
    try {
      final response = await service.loginWithGoogle(token.withBearer());
      response.handleIfNotSuccessful();
      _saveUser(response.body!);
      return response.body!;
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  void _saveUser(LoginResponse loginResponse) {
    database.setUser(loginResponse.toUserTable());
  }

  Future register(RegistrationRequest registrationRequest) async {
    try {
      final Response response = await service.register(registrationRequest);
      response.handleIfNotSuccessful();
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  Future sendResetPasswordMail(String email) async {
    try {
      final Response response = await service.sendResetPasswordMail(email);
      response.handleIfNotSuccessful();
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  Future<UserData?> getUser() {
    return database.getUser();
  }

  Future logoutUser() {
    return database.clearUser();
  }

  Future refreshToken(String refreshToken) async {
    try {
      final Response response =
          await service.refreshToken(RefreshTokenRequest(refreshToken));
      response.handleIfNotSuccessful();
      await _updateUser(response.body!);
      return response.body!;
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  Future _updateUser(RefreshTokenResponse response) {
    return database.updateUser(response);
  }
}
