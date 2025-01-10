import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/app/presentation/app_state_holder.dart';
import 'package:style_me/core/app/presentation/app_view_model.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:style_me/core/theme/theme_manager.dart';

class StyleMeApp extends ConsumerWidget {
  const StyleMeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppStateHolder state = ref.watch(appViewModelProvider);
    final appThemeManager = getIt<ThemeManager>();

    return MaterialApp.router(
      routerConfig: getIt<GoRouter>(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'StyleMe',
      theme: appThemeManager.appThemeLight,
      themeMode: appThemeManager.getModeBy(state.currentTheme),
      darkTheme: appThemeManager.appThemeDark,
    );
  }
}
