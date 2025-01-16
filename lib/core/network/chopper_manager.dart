
import 'package:chopper/chopper.dart';
import 'package:style_me/core/network/json_serializable_converter.dart';
import 'package:style_me/core/network/utils/logging_interceptor.dart';
import 'package:style_me/features/auth/data/models/login_request.dart';
import 'package:style_me/features/auth/data/models/registration_request.dart';
import 'package:style_me/features/auth/data/models/token_response.dart';

class ChopperManager {
  static ChopperClient createClient() => ChopperClient(
          baseUrl: Uri.parse('http://192.168.1.21:8080/api/'),
          converter: JsonSerializableConverter({
            LoginRequest: (json) => LoginRequest.fromJson(json),
            RegistrationRequest: (json) => RegistrationRequest.fromJson(json),
            Token: (json) => Token.fromJson(json),
          }),
          interceptors: [
            LoggingInterceptor(),
          ]);
}
