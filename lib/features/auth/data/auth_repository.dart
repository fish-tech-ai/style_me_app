import 'package:chopper/src/response.dart';
import 'package:style_me/core/extensions/list_ext.dart';
import 'package:style_me/core/extensions/response_ext.dart';
import 'package:style_me/core/network/exceptions/server_exception.dart';
import 'package:style_me/core/network/services/app_service.dart';
import 'package:style_me/features/auth/data/models/email_state_enum.dart';
import 'package:style_me/features/auth/data/models/login_request.dart';
import 'package:style_me/features/auth/data/models/registration_request.dart';
import 'package:style_me/features/auth/data/models/token_response.dart';

class AuthRepository {
  final AppService service;

  AuthRepository(this.service);

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

  Future confirmEmail(String email) async {
    try {
      final Response response = await service.confirmEmail(email);
      response.handleIfNotSuccessful();
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  Future<Token> login(LoginRequest loginRequest) async {
    try {
      final response = await service.login(loginRequest);
      response.handleIfNotSuccessful();
      return response.body!;
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  Future register(RegistrationRequest registrationRequest) async {
    try {
      final Response response = await service.register(registrationRequest);
      response.handleIfNotSuccessful();
    } catch (error) {
      throw ServerException(error.toString());
    }
  }
}
