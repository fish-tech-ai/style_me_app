import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/app/presentation/components/app_status.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/navigation/app_page.dart';
import 'package:style_me/core/views/animators/animated_visibility.dart';
import 'package:style_me/features/auth/presentation/ui_models/anim_direction_enum.dart';
import 'package:style_me/features/settings/presentation/ui_models/change_password_args.dart';

///Initialization point for all operations that need to use localizations, MediaQuery etc.
///This is also a wrapper for whole navigation (the child is the actual page)
class AppWrapper extends ConsumerStatefulWidget {
  final Widget? child;

  const AppWrapper({super.key, required this.child});

  @override
  ConsumerState<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends ConsumerState<AppWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(initApp);
  }

  Future initApp(Duration _) async {
    await ref
        .read(appGlobalViewModelProvider.notifier)
        .initializeAndHandleDeepLinks(
          confirmationSuccessMessage: context.localizations.confirmationSuccess,
          navigateToPasswordReset: ( token) {
            context.push(AppPage.changePasswordPage.path,
                extra: ChangePasswordArgs(token, true));
          },
        );
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appGlobalViewModelProvider);
    return Stack(children: [
      widget.child ?? SizedBox(),
      Positioned(
        left: 0,
        right: 0,
        bottom: MediaQuery.of(context).padding.bottom,
        child: AnimatedVisibility(
          isVisible: !state.isConnected || state.bannerMessage != null,
          animDirection: AnimDirectionEnum.bottomToTop,
          child: AppStatus(
            text: !state.isConnected
                ? context.localizations.connectionError
                : state.bannerMessage?.message != null
                    ? state.bannerMessage?.message ?? ""
                    : context.localizations.unknownError,
            textColor: state.bannerMessage?.isError ?? true
                ? context.colorScheme.onError
                : context.colorScheme.onPrimary,
            color: state.bannerMessage?.isError ?? true
                ? context.colorScheme.error
                : context.colorScheme.primary,
            icon: !state.isConnected
                ? Icons.wifi_off_rounded
                : state.bannerMessage?.isError ?? true
                    ? Icons.error_rounded
                    : Icons.check_circle_rounded,
          ),
        ),
      ),
    ]);
  }
}
