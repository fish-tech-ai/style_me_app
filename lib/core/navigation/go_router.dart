import 'package:flutter_riverpod/src/consumer.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/extensions/widget_ext.dart';
import 'package:style_me/core/navigation/app_nav_observer.dart';
import 'package:style_me/core/navigation/app_page.dart';
import 'package:style_me/features/auth/presentation/pages/auth_page.dart';
import 'package:style_me/features/checkroom/presentation/checkroom_page.dart';
import 'package:style_me/features/home/presentation/home_page.dart';
import 'package:style_me/features/settings/presentation/pages/change_password_page.dart';
import 'package:style_me/features/settings/presentation/pages/privacy_policy_page.dart';
import 'package:style_me/features/settings/presentation/pages/settings_page.dart';
import 'package:style_me/features/settings/presentation/pages/terms_and_contitions_page.dart';
import 'package:style_me/features/settings/presentation/ui_models/change_password_args.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing.dart';
import 'package:style_me/features/wardrobe/data/models/user_photos/user_photo.dart';
import 'package:style_me/features/wardrobe/presentation/pages/clothes/add_clothing_page.dart';
import 'package:style_me/features/wardrobe/presentation/pages/clothes/edit_clothing_page.dart';
import 'package:style_me/features/wardrobe/presentation/pages/user_photos/add_user_photo_page.dart';
import 'package:style_me/features/wardrobe/presentation/pages/user_photos/edit_user_photos_page.dart';
import 'package:style_me/features/wardrobe/presentation/pages/wardrobe_page.dart';

GoRouter getRouter(bool isAuthenticated, WidgetRef ref) => GoRouter(
      initialLocation:
          isAuthenticated ? AppPage.homePage.path : AppPage.authPage.path,
      observers: [AppNavObserver(ref)],
      routes: [
        GoRoute(
          path: AppPage.authPage.path,
          builder: (context, state) => const AuthPage().scopedPage(),
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
          path: AppPage.privacyPolicy.path,
          builder: (context, state) => const PrivacyPolicyPage().scopedPage(),
        ),
        GoRoute(
          path: AppPage.termsAndConditions.path,
          builder: (context, state) =>
              const TermsAndConditionsPage().scopedPage(),
        ),
        GoRoute(
          path: AppPage.changePasswordPage.path,
          builder: (context, state) {
            final ChangePasswordPageArgs args =
                state.extra as ChangePasswordPageArgs;
            return ChangePasswordPage(changePasswordArgs: args).scopedPage();
          },
        ),
        GoRoute(
          path: AppPage.clothingAdd.path,
          builder: (context, state) => const AddClothingPage().scopedPage(),
        ),
        GoRoute(
          path: AppPage.editClothingPage.path,
          builder: (context, state) {
            final Clothing clothing = state.extra as Clothing;
            return EditClothingPage(clothing: clothing).scopedPage();
          },
        ),
        GoRoute(
          path: AppPage.userPhotoAdd.path,
          builder: (context, state) => const AddUserPhotoPage().scopedPage(),
        ),
        GoRoute(
          path: AppPage.editUserPhotoPage.path,
          builder: (context, state) {
            final UserPhoto userPhoto = state.extra as UserPhoto;
            return EditUserPhotoPage(userPhoto: userPhoto).scopedPage();
          },
        ),
      ],
    );
