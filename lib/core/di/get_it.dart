import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:style_me/core/app/data/app_repository.dart';
import 'package:style_me/core/app/domain/usecases/get_current_theme_use_case.dart';
import 'package:style_me/core/app/domain/usecases/save_current_theme_use_case.dart';
import 'package:style_me/core/navigation/go_router.dart';
import 'package:style_me/core/network/chopper.dart';
import 'package:style_me/core/theme/theme_manager.dart';

final getIt = GetIt.instance;

class GetItManager {
  static Future setupGetIt() async {
    getIt.registerLazySingleton(() => router);
    getIt.registerLazySingleton(() => ChopperManager.createClient());
    getIt.registerLazySingleton(() => ThemeManager());
    final sharedPrefs = await SharedPreferences.getInstance();
    getIt.registerLazySingleton(
            () => sharedPrefs);

    ///Global
    getIt.registerFactory(() => AppRepository(getIt()));
    getIt.registerFactory(() => GetCurrentThemeUseCase(getIt()));
    getIt.registerFactory(() => SaveCurrentThemeUseCase(getIt()));
  }
}
