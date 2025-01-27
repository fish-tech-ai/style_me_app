import 'package:chopper/chopper.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:style_me/core/app/data/app_repository.dart';
import 'package:style_me/core/app/domain/usecases/get_current_theme_use_case.dart';
import 'package:style_me/core/app/domain/usecases/save_current_theme_use_case.dart';
import 'package:style_me/core/local/database.dart';
import 'package:style_me/core/navigation/go_router.dart';
import 'package:style_me/core/network/chopper_manager.dart';
import 'package:style_me/core/network/connection.dart';
import 'package:style_me/core/network/services/app_service.dart';
import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/theme/theme_manager.dart';
import 'package:style_me/features/auth/data/auth_repository.dart';
import 'package:style_me/features/auth/domain/check_email_use_case.dart';
import 'package:style_me/features/auth/domain/confirm_email_use_case.dart';
import 'package:style_me/features/auth/domain/login_use_case.dart';
import 'package:style_me/features/auth/domain/register_use_case.dart';

final getIt = GetIt.instance;

class GetItManager {
  static Future setupGetIt() async {
    ///core
    getIt.registerLazySingleton(() => router);
    getIt.registerLazySingleton<ChopperClient>(
        () => ChopperManager.createClient());
    getIt.registerFactory<AppService>(
        () => AppService.create(getIt<ChopperClient>()));
    getIt.registerLazySingleton(() => ThemeManager());
    final sharedPrefs = await SharedPreferences.getInstance();
    getIt.registerLazySingleton(() => sharedPrefs);
    getIt.registerLazySingleton(() => Connection());
    getIt.registerFactory(() => NetworkRequestUtil());
    getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());

    ///Global
    getIt.registerFactory(() => AppRepository(getIt()));
    getIt.registerFactory(() => GetCurrentThemeUseCase(getIt()));
    getIt.registerFactory(() => SaveCurrentThemeUseCase(getIt()));

    ///Auth
    getIt.registerFactory(() => AuthRepository(getIt(), getIt()));
    getIt.registerFactory(() => CheckEmailUseCase(getIt(), getIt()));
    getIt.registerFactory(() => ConfirmEmailUseCase(getIt(), getIt()));
    getIt.registerFactory(() => LoginUseCase(getIt(), getIt()));
    getIt.registerFactory(() => RegisterUseCase(getIt(), getIt()));
  }
}
