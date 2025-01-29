import 'package:chopper/chopper.dart';
import 'package:style_me/features/auth/data/models/login_request.dart';
import 'package:style_me/features/auth/data/models/refresh_token_request.dart';
import 'package:style_me/features/auth/data/models/refresh_token_response.dart';
import 'package:style_me/features/auth/data/models/registration_request.dart';
import 'package:style_me/features/auth/data/models/login_response.dart';

part "app_service.chopper.dart";

@ChopperApi()
abstract class AppService extends ChopperService {
  @Get(path: 'auth/check-email')
  Future<Response> checkEmail(@Query('email') String email);

  @Get(path: 'auth/confirm-email')
  Future<Response> confirmEmail(@Query('email') String email);

  @Post(path: 'auth/register')
  Future<Response> register(@Body() RegistrationRequest registrationRequest);

  @Post(path: 'auth/login')
  Future<Response<LoginResponse>> login(@Body() LoginRequest loginRequest);

  @Post(path: 'auth/refresh')
  Future<Response<RefreshTokenResponse>> refreshToken(
      @Body() RefreshTokenRequest loginRequest);

  static AppService create([ChopperClient? client]) => _$AppService(client);
}
