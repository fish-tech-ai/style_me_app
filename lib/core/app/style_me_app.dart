import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/app/presentation/app_global_state_holder.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/app/presentation/components/app_status.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/navigation/go_router.dart';
import 'package:style_me/core/theme/theme_manager.dart';
import 'package:style_me/core/views/animators/animated_visibility.dart';
import 'package:style_me/features/auth/presentation/ui_models/anim_direction_enum.dart';

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
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'StyleMe',
      theme: appThemeManager.appThemeLight,
      themeMode: appThemeManager.getModeBy(state.currentTheme),
      darkTheme: appThemeManager.appThemeDark,
      builder: (context, child) {
        return Stack(children: [
          child ?? SizedBox(),
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).padding.bottom,
            child: AnimatedVisibility(
              isVisible: !state.isConnected || state.failure != null,
              animDirection: AnimDirectionEnum.bottomToTop,
              child: AppStatus(
                text: !state.isConnected
                    ? context.localizations.connectionError
                    : state.failure?.message != null
                        ? state.failure!.message!
                        : context.localizations.unknownError,
                textColor: context.colorScheme.onError,
                color: context.colorScheme.error,
                icon: !state.isConnected ? Icons.wifi_off_rounded : Icons.error,
              ),
            ),
          ),
        ]);
      },
    );
  }
}
