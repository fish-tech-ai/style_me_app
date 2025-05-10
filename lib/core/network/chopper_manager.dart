import 'package:chopper/chopper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:style_me/core/network/exceptions/expected_error_response.dart';
import 'package:style_me/core/network/json_error_converter.dart';
import 'package:style_me/core/network/json_serializable_converter.dart';
import 'package:style_me/core/network/utils/app_authenticator.dart';
import 'package:style_me/core/network/utils/app_headers_interceptor.dart';
import 'package:style_me/core/network/utils/logging_interceptor.dart';
import 'package:style_me/features/auth/data/models/login_request.dart';
import 'package:style_me/features/auth/data/models/refresh_token_request.dart';
import 'package:style_me/features/auth/data/models/refresh_token_response.dart';
import 'package:style_me/features/auth/data/models/registration_request.dart';
import 'package:style_me/features/auth/data/models/login_response.dart';
import 'package:style_me/features/auth/data/models/reset_password_request.dart';
import 'package:style_me/features/checkroom/data/models/generate_outfit_body.dart';
import 'package:style_me/features/checkroom/data/models/generated_outfit_response.dart';
import 'package:style_me/features/settings/data/models/delete_user_request.dart';
import 'package:style_me/features/settings/data/models/report_request.dart';
import 'package:style_me/features/wardrobe/data/models/io/clothes_response.dart';
import 'package:style_me/features/wardrobe/data/models/io/clothing_confirmation_request.dart';
import 'package:style_me/features/wardrobe/data/models/io/original_image_response.dart';
import 'package:style_me/features/wardrobe/data/models/io/send_clothing_photo_response.dart';
import 'package:style_me/features/wardrobe/data/models/io/send_user_photo_response.dart';
import 'package:style_me/features/wardrobe/data/models/io/update_clothing_request.dart';
import 'package:style_me/features/wardrobe/data/models/io/update_user_photo_request.dart';
import 'package:style_me/features/wardrobe/data/models/io/user_photo_confirmation_request.dart';
import 'package:style_me/features/wardrobe/data/models/io/user_photos_response.dart';

class ChopperManager {
  static ChopperClient createClient(
    AppHeadersInterceptor headersInterceptor,
    AppAuthenticator authenticator,
  ) =>
      ChopperClient(
        baseUrl: Uri.parse(dotenv.env['BASE_URL'] ?? ''),
        converter: JsonSerializableConverter(
          {
            LoginRequest: (json) => LoginRequest.fromJson(json),
            RegistrationRequest: (json) => RegistrationRequest.fromJson(json),
            LoginResponse: (json) => LoginResponse.fromJson(json),
            RefreshTokenRequest: (json) => RefreshTokenRequest.fromJson(json),
            RefreshTokenResponse: (json) => RefreshTokenResponse.fromJson(json),
            ResetPasswordRequest: (json) => ResetPasswordRequest.fromJson(json),
            DeleteUserRequest: (json) => DeleteUserRequest.fromJson(json),
            ReportRequest: (json) => ReportRequest.fromJson(json),
            ClothesResponse: (json) => ClothesResponse.fromJson(json),
            SendClothingPhotoResponse: (json) =>
                SendClothingPhotoResponse.fromJson(json),
            ClothingConfirmationRequest: (json) =>
                ClothingConfirmationRequest.fromJson(json),
            UpdateClothingRequest: (json) =>
                UpdateClothingRequest.fromJson(json),
            UserPhotosResponse: (json) => UserPhotosResponse.fromJson(json),
            UserPhotoConfirmationRequest: (json) =>
                UserPhotoConfirmationRequest.fromJson(json),
            UpdateUserPhotoRequest: (json) =>
                UpdateUserPhotoRequest.fromJson(json),
            OriginalImageUrlResponse: (json) =>
                OriginalImageUrlResponse.fromJson(json),
            SendUserPhotoResponse: (json) =>
                SendUserPhotoResponse.fromJson(json),
            GenerateOutfitBody: (json) => GenerateOutfitBody.fromJson(json),
            GeneratedOutfitResponse: (json) =>
                GeneratedOutfitResponse.fromJson(json),
          },
        ),
        errorConverter:
            JsonErrorConverter((json) => ExpectedErrorResponse.fromJson(json)),
        interceptors: [
          headersInterceptor,
          LoggingInterceptor(),
        ],
        authenticator: authenticator,
      );
}
