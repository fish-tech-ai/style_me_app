import 'package:go_router/go_router.dart';
import 'package:style_me/core/navigation/app_page.dart';

extension NavExt on GoRouter {
  AppPage getCurrentNavTargetPage() {
    return AppPage.getFrom(
        path: routerDelegate.currentConfiguration.matches.last.matchedLocation);
  }
}
