import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/navigation/app_page.dart';
import 'package:style_me/features/settings/presentation/components/settings_item.dart';
import 'package:style_me/features/settings/presentation/ui_models/setting.dart';

class LegalDocumentsPage extends StatelessWidget {
  const LegalDocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 108, top: 12, left: 12, right: 12),
      child: Column(
        children: [
          SettingsItem(
            setting: Setting(
              label: localizations.privacyPolicy,
              actionText: localizations.seeMore,
            ),
            hideDivider: true,
            onItemClicked: (setting) {
              context.push(AppPage.privacyPolicy.path, extra: false);
            },
          ),
          SettingsItem(
            setting: Setting(
              label: localizations.termsAndConditions,
              actionText: localizations.seeMore,
            ),
            onItemClicked: (setting) {
              context.push(AppPage.termsAndConditions.path, extra: false);
            },
          ),
          Divider(height: 1, color: context.theme.hintColor),
        ],
      ),
    );
  }
}
