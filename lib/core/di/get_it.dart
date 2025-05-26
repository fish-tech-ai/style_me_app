import 'package:app_links/app_links.dart';
import 'package:chopper/chopper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:style_me/core/app/data/app_repository.dart';
import 'package:style_me/core/app/domain/usecases/fetch_image_use_case.dart';
import 'package:style_me/core/app/domain/usecases/get_current_theme_use_case.dart';
import 'package:style_me/core/app/domain/usecases/get_language_use_case.dart';
import 'package:style_me/core/app/domain/usecases/get_user_use_case.dart';
import 'package:style_me/core/app/domain/usecases/load_app_legals_to_cache.dart';
import 'package:style_me/core/app/domain/usecases/logout_user_use_case.dart';
import 'package:style_me/core/app/domain/usecases/refresh_token_use_case.dart';
import 'package:style_me/core/app/domain/usecases/save_current_theme_use_case.dart';
import 'package:style_me/core/app/domain/usecases/set_language_use_case.dart';
import 'package:style_me/core/local/database.dart';
import 'package:style_me/core/network/chopper_manager.dart';
import 'package:style_me/core/network/connection.dart';
import 'package:style_me/core/network/services/app_service.dart';
import 'package:style_me/core/network/services/auth_service.dart';
import 'package:style_me/core/network/services/clothes_service.dart';
import 'package:style_me/core/network/services/outfit_service.dart';
import 'package:style_me/core/network/services/user_photos_service.dart';
import 'package:style_me/core/network/services/user_service.dart';
import 'package:style_me/core/network/utils/aes_encryptor.dart';
import 'package:style_me/core/network/utils/app_authenticator.dart';
import 'package:style_me/core/network/utils/app_headers_interceptor.dart';
import 'package:style_me/core/network/utils/image_process/image_fetcher.dart';
import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/theme/theme_manager.dart';
import 'package:style_me/core/utils/deep_link_manager.dart';
import 'package:style_me/core/utils/google_auth_service.dart';
import 'package:style_me/core/utils/token_authenticator.dart';
import 'package:style_me/core/views/encrypted_image/isolated_decrypt_manager.dart';
import 'package:style_me/features/auth/data/auth_repository.dart';
import 'package:style_me/features/checkroom/domain/generate_outfit_use_case.dart';
import 'package:style_me/features/checkroom/domain/get_updated_selected_clothes_use_case.dart';
import 'package:style_me/features/checkroom/domain/get_user_original_photos_use_case.dart';
import 'package:style_me/features/home/data/outfit_repository.dart';
import 'package:style_me/features/home/domain/download_to_gallery_with_permissions_use_case.dart';
import 'package:style_me/features/home/domain/get_favorite_outfits_use_case.dart';
import 'package:style_me/features/home/domain/get_original_outfit_photo_use_case.dart';
import 'package:style_me/features/home/domain/get_recent_and_favorite_outfit_use_case.dart';
import 'package:style_me/features/home/domain/get_recent_outfits_use_case.dart';
import 'package:style_me/features/home/domain/set_is_outfit_favorite_use_case.dart';
import 'package:style_me/features/settings/data/settings_repository.dart';
import 'package:style_me/features/settings/domain/add_report_use_case.dart';
import 'package:style_me/features/settings/domain/change_password_use_case.dart';
import 'package:style_me/features/auth/domain/check_email_use_case.dart';
import 'package:style_me/features/auth/domain/confirm_email_use_case.dart';
import 'package:style_me/features/auth/domain/login_use_case.dart';
import 'package:style_me/features/auth/domain/login_with_google_use_case.dart';
import 'package:style_me/features/auth/domain/register_use_case.dart';
import 'package:style_me/features/auth/domain/resend_confirmation_use_case.dart';
import 'package:style_me/features/auth/domain/send_reset_password_mail_use_case.dart';
import 'package:style_me/features/settings/domain/delete_account_use_case.dart';
import 'package:style_me/features/wardrobe/data/wardrobe_repository.dart';
import 'package:style_me/features/wardrobe/domain/clothing/clear_clothing_photo_use_case.dart';
import 'package:style_me/features/wardrobe/domain/clothing/confirm_clothing_photo_use_case.dart';
import 'package:style_me/features/wardrobe/domain/clothing/delete_clothing_use_case.dart';
import 'package:style_me/features/wardrobe/domain/clothing/get_clothes_use_case.dart';
import 'package:style_me/features/wardrobe/domain/clothing/send_clothing_photo_use_case.dart';
import 'package:style_me/features/wardrobe/domain/clothing/update_clothing_use_case.dart';
import 'package:style_me/features/wardrobe/domain/clothing/get_original_clothing_image_url_use_case.dart';
import 'package:style_me/features/wardrobe/domain/user_photo/clear_user_photo_use_case.dart';
import 'package:style_me/features/wardrobe/domain/user_photo/confirm_user_photo_use_case.dart';
import 'package:style_me/features/wardrobe/domain/user_photo/delete_user_photo_use_case.dart';
import 'package:style_me/features/wardrobe/domain/user_photo/get_original_user_image_url_use_case.dart';
import 'package:style_me/features/wardrobe/domain/user_photo/get_user_photos_use_case.dart';
import 'package:style_me/features/wardrobe/domain/user_photo/send_user_photo_use_case.dart';
import 'package:style_me/features/wardrobe/domain/user_photo/update_user_photo_use_case.dart';

final getIt = GetIt.instance;

class GetItManager {
  static Future setupGetIt() async {
    ///core
    getIt.registerLazySingleton<ChopperClient>(
        () => ChopperManager.createClient(getIt(), getIt()));
    getIt.registerFactory(() => TokenAuthenticator());
    getIt.registerFactory(() => AppHeadersInterceptor());
    getIt.registerFactory(() => AppAuthenticator(getIt()));
    getIt.registerFactory<AuthService>(
        () => AuthService.create(getIt<ChopperClient>()));
    getIt.registerFactory<UserService>(
        () => UserService.create(getIt<ChopperClient>()));
    getIt.registerFactory<AppService>(
        () => AppService.create(getIt<ChopperClient>()));
    getIt.registerFactory<ClothesService>(
        () => ClothesService.create(getIt<ChopperClient>()));
    getIt.registerFactory<UserPhotosService>(
        () => UserPhotosService.create(getIt<ChopperClient>()));
    getIt.registerFactory<OutfitService>(
        () => OutfitService.create(getIt<ChopperClient>()));
    getIt.registerLazySingleton(() => ThemeManager());
    final sharedPrefs = await SharedPreferences.getInstance();
    getIt.registerLazySingleton(() => sharedPrefs);
    getIt.registerLazySingleton(() => Connection());
    getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());

    ///Global
    getIt.registerFactory(() => AppRepository(getIt(), getIt()));
    getIt.registerFactory(() => GetCurrentThemeUseCase(getIt()));
    getIt.registerFactory(() => SaveCurrentThemeUseCase(getIt()));
    getIt.registerFactory(() => FetchImageUseCase());
    getIt.registerFactory(() => LoadAppLegalsToCache());

    ///Utils
    getIt.registerFactory(() => NetworkRequestUtil());
    getIt.registerLazySingleton(() => AppLinks());
    getIt.registerLazySingleton(() => DeepLinkManager(getIt()));
    getIt.registerLazySingleton(() => AESEncryptor());
    getIt.registerFactory(() => ImageFetcher(getIt()));
    getIt.registerLazySingleton(() => IsolatedDecryptManager());

    ///Global auth
    getIt.registerFactory(() => GoogleSignIn.standard());
    getIt.registerFactory(() => FirebaseAuth.instance);
    getIt.registerFactory(() => GoogleAuthService(getIt(), getIt()));
    getIt.registerFactory(() => GetUserUseCase(getIt()));
    getIt.registerFactory(() => LogoutUserUseCase(getIt(), getIt()));
    getIt.registerFactory(() => RefreshTokenUseCase(getIt(), getIt()));

    ///Auth
    getIt.registerFactory(() => AuthRepository(getIt(), getIt()));
    getIt.registerFactory(() => CheckEmailUseCase(getIt(), getIt()));
    getIt.registerFactory(() => ConfirmEmailUseCase(getIt(), getIt()));
    getIt.registerFactory(() => LoginUseCase(getIt(), getIt()));
    getIt.registerFactory(() => LoginWithGoogleUseCase(getIt(), getIt()));
    getIt.registerFactory(() => RegisterUseCase(getIt(), getIt()));
    getIt.registerFactory(() => ResendConfirmationUseCase(getIt(), getIt()));
    getIt.registerFactory(() => SendResetPasswordMailUseCase(getIt(), getIt()));

    ///Settings
    getIt.registerFactory(() => SettingsRepository(getIt(), getIt()));
    getIt.registerFactory(() => ChangePasswordUseCase(getIt(), getIt()));
    getIt.registerFactory(() => DeleteAccountUseCase(getIt(), getIt()));
    getIt.registerFactory(() => GetLanguageUseCase(getIt()));
    getIt.registerFactory(() => SetLanguageUseCase(getIt()));
    getIt.registerFactory(() => AddReportUseCase(getIt(), getIt()));

    ///Wardrobe
    getIt.registerFactory(() => WardrobeRepository(getIt(), getIt()));

    ///Wardrobe clothes
    getIt.registerFactory(() => GetClothesUseCase(getIt(), getIt()));
    getIt.registerFactory(
        () => SendClothingPhotoUseCase(getIt(), getIt(), getIt()));
    getIt.registerFactory(() => ConfirmClothingPhotoUseCase(getIt(), getIt()));
    getIt.registerFactory(() => ClearClothingPhotoUseCase(getIt(), getIt()));
    getIt.registerFactory(() => DeleteClothingUseCase(getIt(), getIt()));
    getIt.registerFactory(() => UpdateClothingUseCase(getIt(), getIt()));
    getIt.registerFactory(
        () => GetOriginalClothingImageUrlUseCase(getIt(), getIt()));

    ///Wardrobe user photos
    getIt.registerFactory(() => GetUserPhotosUseCase(getIt(), getIt()));
    getIt
        .registerFactory(() => SendUserPhotoUseCase(getIt(), getIt(), getIt()));
    getIt.registerFactory(() => ConfirmUserPhotoUseCase(getIt(), getIt()));
    getIt.registerFactory(() => ClearUserPhotoUseCase(getIt(), getIt()));
    getIt.registerFactory(() => DeleteUserPhotoUseCase(getIt(), getIt()));
    getIt.registerFactory(() => UpdateUserPhotoUseCase(getIt(), getIt()));
    getIt.registerFactory(
        () => GetOriginalUserImageUrlUseCase(getIt(), getIt()));

    ///Checkroom
    getIt.registerFactory(() => GetUserOriginalPhotosUseCase(getIt(), getIt()));
    getIt.registerFactory(() => GetUpdatedSelectedClothesUseCase());
    getIt.registerFactory(() => GenerateOutfitUseCase(getIt(), getIt()));

    ///Home
    getIt.registerFactory(() => OutfitRepository(getIt()));
    getIt.registerFactory(() => GetFavoriteOutfitsUseCase(getIt(), getIt()));
    getIt
        .registerFactory(() => GetOriginalOutfitPhotoUseCase(getIt(), getIt()));
    getIt.registerFactory(() => GetRecentOutfitsUseCase(getIt(), getIt()));
    getIt.registerFactory(() => SetIsOutfitFavoriteUseCase(getIt(), getIt()));
    getIt.registerFactory(
        () => GetRecentAndFavoriteOutfitUseCase(getIt(), getIt()));
    getIt.registerFactory(
        () => DownloadToGalleryWithPermissionsUseCase(getIt(), getIt(), getIt()));
  }
}
