import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style_me/core/extensions/widget_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/features/settings/presentation/components/settings_banner.dart';
import 'package:style_me/features/settings/presentation/components/settings_item.dart';
import 'package:style_me/features/settings/presentation/state/view_models/settings_view_model.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsViewModelProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              SettingsBanner(email: state.userEmail),
              Column(
                children: state.appSettings
                    .map((setting) => SettingsItem(setting: setting))
                    .toList(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      localizations.accountSettings,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  ...state.accountSettings
                      .map((setting) => SettingsItem(setting: setting)),
                ],
              )
            ],
          ).orLoading(state.isLoading),
        ),
      ),
    );
  }
}
