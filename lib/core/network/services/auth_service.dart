import 'package:chopper/chopper.dart';
import 'package:style_me/core/utils/constants.dart';
import 'package:style_me/features/auth/data/models/login_request.dart';
import 'package:style_me/features/auth/data/models/refresh_token_request.dart';
import 'package:style_me/features/auth/data/models/refresh_token_response.dart';
import 'package:style_me/features/auth/data/models/registration_request.dart';
import 'package:style_me/features/auth/data/models/login_response.dart';

part "auth_service.chopper.dart";

@ChopperApi(baseUrl: "/auth")
abstract class AuthService extends ChopperService {
  @Get(path: '/check-email')
  Future<Response> checkEmail(@Query('email') String email);

  @Get(path: '/confirm-email')
  Future<Response> confirmEmail(
      @Header(NetworkHeaders.authorization) String token);

  @Post(path: '/register')
  Future<Response> register(@Body() RegistrationRequest registrationRequest);

  @Post(path: '/login')
  Future<Response<LoginResponse>> login(@Body() LoginRequest loginRequest);

  @Post(path: 'login/google')
  Future<Response<LoginResponse>> loginWithGoogle(
      @Header(NetworkHeaders.authorization) String token);

  @Post(path: '/refresh')
  Future<Response<RefreshTokenResponse>> refreshToken(
      @Body() RefreshTokenRequest loginRequest);

  @Post(path: '/resend/confirmation-email')
  Future<Response> resendConfirmation(@Query('email') String email);

  @Post(path: '/forgot-password')
  Future<Response> sendResetPasswordMail(@Query('email') String email);

  static AuthService create([ChopperClient? client]) => _$AuthService(client);
}
