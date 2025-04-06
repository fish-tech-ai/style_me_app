import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/app/presentation/components/app_status.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/extensions/go_router_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/navigation/app_page.dart';
import 'package:style_me/core/views/animators/animated_visibility.dart';
import 'package:style_me/core/views/app_bottom_nav_bar.dart';
import 'package:style_me/features/auth/presentation/ui_models/anim_direction_enum.dart';
import 'package:style_me/features/settings/presentation/ui_models/change_password_args.dart';

///Initialization point for all operations that need to use localizations, MediaQuery etc.
///This is also a wrapper for whole navigation (the child is the actual page)
class AppWrapper extends ConsumerStatefulWidget {
  final Widget? child;
  final GoRouter router;

  const AppWrapper({super.key, required this.child, required this.router});

  @override
  ConsumerState<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends ConsumerState<AppWrapper> {
  EdgeInsets? appInsetsPadding;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(initApp);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    LocalizationHelper.init(context.localizations);
    final currentSysPadding = MediaQuery.of(context).padding;
    if (currentSysPadding.bottom > 0) {
      appInsetsPadding ??= currentSysPadding;
    }
  }

  Future initApp(Duration _) async {
    final viewModel = ref.read(appGlobalViewModelProvider.notifier);
    viewModel.initBottomNavItems();
    _onRouteChange(viewModel);
    widget.router.routerDelegate.addListener(() {
      _onRouteChange(viewModel);
    });
    await viewModel.initializeAndHandleDeepLinks(
      navigateToPasswordReset: (token) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.router.push(AppPage.changePasswordPage.path,
              extra: ChangePasswordPageArgs(token, true));
        });
      },
    );
    FlutterNativeSplash.remove();
  }

  void _onRouteChange(AppGlobalViewModel viewModel) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentAppPage = widget.router.getCurrentNavTargetPage();
      _runOtherRouterActions(widget.router);
      viewModel.setBottomNavBarVisibility(
      currentAppPage.shouldShowBottomNavBar);
    });
  }

  void _runOtherRouterActions(GoRouter router) {
    router;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appGlobalViewModelProvider);
    final bottomBarState = ref.watch(
        appGlobalViewModelProvider.select((state) => state.bottomBarState));
    return Stack(children: [
      Container(
        padding: bottomBarState.isVisible ? appInsetsPadding : null,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              Expanded(
                child: widget.child ?? SizedBox(),
              ),
              AppBottomNavBar(widget.router)
            ],
          ),
        ),
      ),
      Positioned(
        left: 0,
        right: 0,
        bottom: MediaQuery.of(context).padding.bottom,
        child: AnimatedVisibility(
          isVisible: !state.isConnected || state.bannerMessage.isVisible,
          animDirection: AnimDirectionEnum.bottomToTop,
          child: AppStatus(
            text: !state.isConnected
                ? localizations.connectionError
                : state.bannerMessage.message.isNotEmpty
                    ? state.bannerMessage.message
                    : localizations.unknownError,
            textColor: state.bannerMessage.isError
                ? context.colorScheme.onError
                : context.colorScheme.onPrimary,
            color: state.bannerMessage.isError
                ? context.colorScheme.error
                : context.colorScheme.primary,
            icon: !state.isConnected
                ? Icons.wifi_off_rounded
                : state.bannerMessage.isError
                    ? Icons.error_rounded
                    : Icons.check_circle_rounded,
          ),
        ),
      ),
    ]);
  }
}
