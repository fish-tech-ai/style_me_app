import 'package:chopper/chopper.dart';
import 'package:style_me/core/utils/constants.dart';
import 'package:style_me/features/auth/data/models/reset_password_request.dart';

part "user_service.chopper.dart";

@ChopperApi(baseUrl: "/user")
abstract class UserService extends ChopperService {
  @Post(path: '/reset-password')
  Future<Response> resetPassword(@Body() ResetPasswordRequest request,
      @Header(NetworkHeaders.authorization) String token);

  static UserService create([ChopperClient? client]) => _$UserService(client);
}
