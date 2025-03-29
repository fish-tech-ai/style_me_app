import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/extensions/locale_ext.dart';
import 'package:style_me/core/utils/constants.dart';

class SettingsLanguageBottomSheetContent extends ConsumerWidget {
  final Function(Locale) onItemSelected;

  const SettingsLanguageBottomSheetContent(
      {super.key, required this.onItemSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLang = ref.watch(appGlobalViewModelProvider
        .select((globalState) => globalState.lang!));
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          _buildLocaleItem(
            context: context,
            lang: Locale(LanguageCodeConst.english),
            selectedLang: currentLang,
            onItemClicked: onItemSelected,
          ),
          _buildDivider(context),
          _buildLocaleItem(
            context: context,
            lang: Locale(LanguageCodeConst.polish),
            selectedLang: currentLang,
            onItemClicked: onItemSelected,
          ),
        ],
      ),
    );
  }

  Widget _buildLocaleItem({
    required BuildContext context,
    required Locale lang,
    required Locale selectedLang,
    required Function(Locale) onItemClicked,
  }) {
    final isSelected = lang.toLanguageTag() == selectedLang.toLanguageTag();
    return InkWell(
      onTap: () {
        onItemClicked(lang);
      },
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              lang.getLanguageText(),
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
