import 'package:app_links/app_links.dart';
import 'package:style_me/core/extensions/global_ext.dart';
import 'package:style_me/core/extensions/string_ext.dart';

class DeepLinkManager {
  final AppLinks _appLinks;

  DeepLinkManager(this._appLinks);

  Future initializeAndHandleDeepLinks(
    Function(String token) navigateToPasswordReset,
    Function(String token) onEmailConfirmDeepLink,
    Function() onConfirmationFailed,
  ) async {
    _appLinks.uriLinkStream.listen((Uri deepLink) {
      _handleDeepLink(deepLink, navigateToPasswordReset, onEmailConfirmDeepLink,
          onConfirmationFailed);
    }, onError: (e) {
      debugMessagePrint(e.toString());
    });
  }

  void _handleDeepLink(
    Uri deepLink,
    Function(String token) navigateToPasswordReset,
    Function(String token) onEmailConfirmDeepLink,
    Function() onConfirmationFailed,
  ) async {
    debugMessagePrint("Fetched deepLink: $deepLink");
    String? token = deepLink.queryParameters["token"];
    if (token == null || token.isTokenExpired()) {
      onConfirmationFailed();
      return;
    }
    if (deepLink.path == "/confirm-email") {
      await onEmailConfirmDeepLink(token);
    } else if (deepLink.path == "/reset-password") {
      navigateToPasswordReset(token);
    }
  }
}
