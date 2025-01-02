import 'package:get_it/get_it.dart';
import 'package:style_me/core/navigation/go_router.dart';
import 'package:style_me/core/network/chopper.dart';
import 'package:style_me/core/theme/theme_manager.dart';

final getIt = GetIt.instance;

class GetItManager {
  static void setupGetIt() {
    getIt.registerLazySingleton(() => router);

    getIt.registerLazySingleton(() => ChopperManager.createClient());

    getIt.registerLazySingleton(() => ThemeManager());

  }
}