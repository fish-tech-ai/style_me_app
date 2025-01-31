import 'package:chopper/chopper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:style_me/core/network/json_serializable_converter.dart';
import 'package:style_me/core/network/utils/logging_interceptor.dart';
import 'package:style_me/features/auth/data/models/login_request.dart';
import 'package:style_me/features/auth/data/models/refresh_token_request.dart';
import 'package:style_me/features/auth/data/models/refresh_token_response.dart';
import 'package:style_me/features/auth/data/models/registration_request.dart';
import 'package:style_me/features/auth/data/models/login_response.dart';

class ChopperManager {
  static ChopperClient createClient() => ChopperClient(
        baseUrl: Uri.parse(dotenv.env['BASE_URL'] ?? ''),
        converter: JsonSerializableConverter({
          LoginRequest: (json) => LoginRequest.fromJson(json),
          RegistrationRequest: (json) => RegistrationRequest.fromJson(json),
          LoginResponse: (json) => LoginResponse.fromJson(json),
          RefreshTokenRequest: (json) => RefreshTokenRequest.fromJson(json),
          RefreshTokenResponse: (json) => RefreshTokenResponse.fromJson(json),
        }),
        interceptors: [
          HeadersInterceptor({'API-KEY': dotenv.env['API_KEY'] ?? ''}),
          LoggingInterceptor(),
        ],
      );
}
