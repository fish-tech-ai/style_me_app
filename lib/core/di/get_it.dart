import 'package:app_links/app_links.dart';
import 'package:chopper/chopper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:style_me/core/app/data/app_repository.dart';
import 'package:style_me/core/app/domain/usecases/get_current_theme_use_case.dart';
import 'package:style_me/core/app/domain/usecases/get_language_use_case.dart';
import 'package:style_me/core/app/domain/usecases/get_user_use_case.dart';
import 'package:style_me/core/app/domain/usecases/logout_user_use_case.dart';
import 'package:style_me/core/app/domain/usecases/refresh_token_use_case.dart';
import 'package:style_me/core/app/domain/usecases/save_current_theme_use_case.dart';
import 'package:style_me/core/app/domain/usecases/set_language_use_case.dart';
import 'package:style_me/core/local/database.dart';
import 'package:style_me/core/network/chopper_manager.dart';
import 'package:style_me/core/network/connection.dart';
import 'package:style_me/core/network/services/auth_service.dart';
import 'package:style_me/core/network/services/user_service.dart';
import 'package:style_me/core/network/utils/app_authenticator.dart';
import 'package:style_me/core/network/utils/app_headers_interceptor.dart';
import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/theme/theme_manager.dart';
import 'package:style_me/core/utils/deep_link_manager.dart';
import 'package:style_me/core/utils/google_auth_service.dart';
import 'package:style_me/core/utils/token_authenticator.dart';
import 'package:style_me/features/auth/data/auth_repository.dart';
import 'package:style_me/features/settings/data/settings_repository.dart';
import 'package:style_me/features/settings/domain/change_password_use_case.dart';
import 'package:style_me/features/auth/domain/check_email_use_case.dart';
import 'package:style_me/features/auth/domain/confirm_email_use_case.dart';
import 'package:style_me/features/auth/domain/login_use_case.dart';
import 'package:style_me/features/auth/domain/login_with_google_use_case.dart';
import 'package:style_me/features/auth/domain/register_use_case.dart';
import 'package:style_me/features/auth/domain/resend_confirmation_use_case.dart';
import 'package:style_me/features/auth/domain/send_reset_password_mail_use_case.dart';
import 'package:style_me/features/settings/domain/delete_account_use_case.dart';

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
    getIt.registerLazySingleton(() => ThemeManager());
    final sharedPrefs = await SharedPreferences.getInstance();
    getIt.registerLazySingleton(() => sharedPrefs);
    getIt.registerLazySingleton(() => Connection());
    getIt.registerFactory(() => NetworkRequestUtil());
    getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());
    getIt.registerLazySingleton(() => AppLinks());
    getIt.registerLazySingleton(() => DeepLinkManager(getIt()));

    ///Global
    getIt.registerFactory(() => AppRepository(getIt(), getIt()));
    getIt.registerFactory(() => GetCurrentThemeUseCase(getIt()));
    getIt.registerFactory(() => SaveCurrentThemeUseCase(getIt()));

    ///Global auth
    getIt.registerFactory(() => GoogleSignIn.standard());
    getIt.registerFactory(() => FirebaseAuth.instance);
    getIt.registerFactory(() => GoogleAuthService(getIt(), getIt()));
    getIt.registerFactory(() => GetUserUseCase(getIt()));
    getIt.registerFactory(() => LogoutUserUseCase(getIt()));
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
    getIt.registerFactory(() => SettingsRepository(getIt()));
    getIt.registerFactory(() => ChangePasswordUseCase(getIt(), getIt()));
    getIt.registerFactory(() => DeleteAccountUseCase(getIt(), getIt()));
    getIt.registerFactory(() => GetLanguageUseCase(getIt()));
    getIt.registerFactory(() => SetLanguageUseCase(getIt()));
  }
}
