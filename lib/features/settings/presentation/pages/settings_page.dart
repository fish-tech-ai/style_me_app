import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style_me/core/extensions/widget_ext.dart';
import 'package:style_me/features/settings/presentation/components/settings_banner.dart';
import 'package:style_me/features/settings/presentation/state/view_models/settings_view_model.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsViewModelProvider);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Column(
          spacing: 12,
          children: [
            SettingsBanner(email: state.userEmail),
          ],
        ).orLoading(state.isLoading),
      ),
    );
  }
}
