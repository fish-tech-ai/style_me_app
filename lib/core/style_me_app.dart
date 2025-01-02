import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:style_me/core/theme/theme_manager.dart';

class StyleMeApp extends StatelessWidget {
  const StyleMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appThemeManager = getIt<ThemeManager>();
    return MaterialApp.router(
      routerConfig: getIt<GoRouter>(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'StyleMe',
      theme: appThemeManager.appThemeLight,
      themeMode: ThemeMode.system,
      darkTheme: appThemeManager.appThemeDark,
    );
  }
}
