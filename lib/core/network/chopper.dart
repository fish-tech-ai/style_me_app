import 'package:chopper/chopper.dart';
import 'package:style_me/core/network/json_serializable_converter.dart';
import 'package:style_me/core/network/services/app_service.dart';
import 'package:style_me/features/auth/data/models/login_request.dart';
import 'package:style_me/features/auth/data/models/registration_request.dart';
import 'package:style_me/features/auth/data/models/token_response.dart';

class ChopperManager {
  static ChopperClient createClient() => ChopperClient(
      baseUrl: Uri.parse('http://localhost:8080/api/'),
      services: [
        AppService.create(ChopperClient()),
      ],
      converter: JsonSerializableConverter({
        LoginRequest: (json) => LoginRequest.fromJson(json),
        RegistrationRequest: (json) => RegistrationRequest.fromJson(json),
        Token: (json) => Token.fromJson(json),
      }),
      interceptors: [
        HttpLoggingInterceptor(),
      ]);
}
