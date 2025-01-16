import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:style_me/core/app/data/app_repository.dart';
import 'package:style_me/core/app/domain/usecases/get_current_theme_use_case.dart';
import 'package:style_me/core/app/domain/usecases/save_current_theme_use_case.dart';
import 'package:style_me/core/navigation/go_router.dart';
import 'package:style_me/core/network/chopper.dart';
import 'package:style_me/core/network/connection.dart';
import 'package:style_me/core/network/services/app_service.dart';
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
    getIt.registerLazySingleton(() => ChopperManager.createClient());
    getIt.registerFactory(() => AppService.create(getIt()));
    getIt.registerLazySingleton(() => ThemeManager());
    final sharedPrefs = await SharedPreferences.getInstance();
    getIt.registerLazySingleton(() => sharedPrefs);
    getIt.registerLazySingleton(() => Connection());

    ///Global
    getIt.registerFactory(() => AppRepository(getIt()));
    getIt.registerFactory(() => GetCurrentThemeUseCase(getIt()));
    getIt.registerFactory(() => SaveCurrentThemeUseCase(getIt()));

    ///Auth
    getIt.registerFactory(() => AuthRepository(getIt()));
    getIt.registerFactory(() => CheckEmailUseCase(getIt(), getIt()));
    getIt.registerFactory(() => ConfirmEmailUseCase(getIt(), getIt()));
    getIt.registerFactory(() => LoginUseCase(getIt(), getIt()));
    getIt.registerFactory(() => RegisterUseCase(getIt(), getIt()));
  }
}
