import 'package:app_links/app_links.dart';
import 'package:style_me/core/extensions/global_ext.dart';

class DeepLinkManager {
  final AppLinks _appLinks;

  DeepLinkManager(this._appLinks);

  Future initializeAndHandleDeepLinks(
    Function(String token) navigateToPasswordReset,
    Function(String token) onEmailConfirmDeepLink,
  ) async {
    _appLinks.uriLinkStream.listen((Uri deepLink) {
      _handleDeepLink(
          deepLink, navigateToPasswordReset, onEmailConfirmDeepLink);
    }, onError: (e) {
      debugMessagePrint(e.toString());
    });

    Uri? initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      _handleDeepLink(
          initialLink, navigateToPasswordReset, onEmailConfirmDeepLink);
    }
  }

  void _handleDeepLink(
    Uri deepLink,
    Function(String token) navigateToPasswordReset,
    Function(String token) onEmailConfirmDeepLink,
  ) async {
    debugMessagePrint("Fetched deepLink: $deepLink");
    String? token = deepLink.queryParameters["token"];
    if (deepLink.path == "/confirm-email" && token != null) {
      await onEmailConfirmDeepLink(token);
    } else if (deepLink.path == "/reset-password" && token != null) {
      navigateToPasswordReset(token);
    }
  }
}
