import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/extensions/global_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/utils/constants.dart';
import 'package:style_me/core/views/buttons/app_button.dart';
import 'package:style_me/core/views/popups/app_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showAuthDemoDialogIfNeeded(BuildContext context) async {
  final sharedPreferences = getIt<SharedPreferences>();
  if (sharedPreferences.getBool(SharedPrefsConst.authDemoDialogShownKey) ??
      false) {
    return;
  }
  await sharedPreferences.setBool(
      SharedPrefsConst.authDemoDialogShownKey, true);
  if (!context.mounted) {
    return;
  }
  showAppDialog(context: context, child: const AuthDemoDialog());
}

class AuthDemoDialog extends StatelessWidget {
  const AuthDemoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: localizations.authDemoDialogTitle,
      description: localizations.authDemoDialogDescription,
      buttonsRow: Column(
        spacing: GlobalUiConst.paddingNormal,
        children: [
          Text(
            localizations.authDemoDialogVideoInfo,
            textAlign: TextAlign.center,
          ),
          InkWell(
            onTap: () {
              launchUrl(Uri.parse(GlobalUiConst.demoVideoUrl),
                  mode: LaunchMode.externalApplication);
            },
            child: Text(
              GlobalUiConst.demoVideoUrl,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.colorScheme.primary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          AppButton(
            text: localizations.gotIt,
            height: 46,
            padding: EdgeInsets.symmetric(horizontal: 24),
            onClick: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
