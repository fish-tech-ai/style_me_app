import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/extensions/theme_ext.dart';

class SettingsThemeBottomSheetContent extends ConsumerWidget {
  final Function(Brightness?) onItemSelected;

  const SettingsThemeBottomSheetContent(
      {super.key, required this.onItemSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(appGlobalViewModelProvider
        .select((globalState) => globalState.currentTheme));
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          _buildThemeItem(
            context: context,
            theme: null,
            selectedTheme: currentTheme,
            onItemClicked: onItemSelected,
          ),
          _buildDivider(context),
          _buildThemeItem(
            context: context,
            theme: Brightness.dark,
            selectedTheme: currentTheme,
            onItemClicked: onItemSelected,
          ),
          _buildDivider(context),
          _buildThemeItem(
            context: context,
            theme: Brightness.light,
            selectedTheme: currentTheme,
            onItemClicked: onItemSelected,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeItem({
    required BuildContext context,
    required Brightness? theme,
    required Brightness? selectedTheme,
    required Function(Brightness?) onItemClicked,
  }) {
    final isSelected = theme == selectedTheme;
    return InkWell(
      onTap: () {
        onItemClicked(theme);
      },
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              theme.getThemeText(),
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SvgPicture.asset(
              isSelected
                  ? "assets/radio_button_selected.svg"
                  : "assets/radio_button.svg",
              colorFilter: ColorFilter.mode(
                  isSelected
                      ? context.colorScheme.primary
                      : context.colorScheme.onSurface,
                  BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(height: 1, color: context.theme.hintColor);
  }
}
