import 'package:go_router/go_router.dart';
import 'package:style_me/core/navigation/app_page.dart';
import 'package:style_me/features/auth/presentation/pages/auth_page.dart';
import 'package:style_me/features/checkroom/presentation/checkroom_page.dart';
import 'package:style_me/features/home/presentation/home_page.dart';
import 'package:style_me/features/settings/presentation/pages/change_password_page.dart';
import 'package:style_me/features/settings/presentation/pages/settings_page.dart';
import 'package:style_me/features/settings/presentation/ui_models/change_password_args.dart';
import 'package:style_me/features/wardrobe/presentation/wardrobe_page.dart';

GoRouter getRouter(bool isAuthenticated) => GoRouter(
      initialLocation:
          isAuthenticated ? AppPage.homePage.path : AppPage.authPage.path,
      routes: [
        GoRoute(
          path: AppPage.authPage.path,
          builder: (context, state) => const AuthPage(),
        ),
        GoRoute(
          path: AppPage.homePage.path,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: AppPage.checkroom.path,
          builder: (context, state) => const CheckroomPage(),
        ),
        GoRoute(
          path: AppPage.wardrobe.path,
          builder: (context, state) => const WardrobePage(),
        ),
        GoRoute(
          path: AppPage.settings.path,
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: AppPage.changePasswordPage.path,
          builder: (context, state) {
            final ChangePasswordPageArgs args = state.extra as ChangePasswordPageArgs;
            return ChangePasswordPage(changePasswordArgs: args);
          },
        ),
      ],
    );
