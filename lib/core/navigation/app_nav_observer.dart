import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style_me/core/navigation/app_page.dart';
import 'package:style_me/features/wardrobe/presentation/state/viewmodels/wardrobe_view_model.dart';

class AppNavObserver extends NavigatorObserver {
  final WidgetRef ref;

  AppNavObserver(this.ref);

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final popAppPageSource =
        AppPage.getFrom(path: route.settings.name ?? AppPage.homePage.path);
    if (popAppPageSource == AppPage.clothingAdd ||
        popAppPageSource == AppPage.userPhotoAdd) {
      ref.invalidate(wardrobeViewModelProvider);
    }
  }
}
