import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/app/presentation/app_global_state_holder.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/app/presentation/components/app_wrapper.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/navigation/go_router.dart';
import 'package:style_me/core/theme/theme_manager.dart';

class StyleMeApp extends ConsumerStatefulWidget {
  final bool isAuthenticated;

  const StyleMeApp(this.isAuthenticated, {super.key});

  @override
  ConsumerState<StyleMeApp> createState() => _StyleMeAppState();
}

class _StyleMeAppState extends ConsumerState<StyleMeApp> {
  late final GoRouter router;

  @override
  void initState() {
    super.initState();
    router = getRouter(widget.isAuthenticated);
  }

  @override
  Widget build(BuildContext context) {
    final AppGlobalStateHolder state = ref.watch(appGlobalViewModelProvider);
    final ThemeManager appThemeManager = getIt<ThemeManager>();

    return MaterialApp.router(
      routerConfig: router,
      locale: state.lang,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'StyleMe',
      theme: appThemeManager.appThemeLight,
      themeMode: appThemeManager.getModeBy(state.currentTheme),
      darkTheme: appThemeManager.appThemeDark,
      builder: (context, child) {
        LocalizationHelper.init(context);
        return AppWrapper(router: router, child: child);
      },
    );
  }
}
