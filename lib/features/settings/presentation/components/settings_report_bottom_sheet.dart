import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/views/buttons/app_button.dart';
import 'package:style_me/core/views/input/app_dropdown_button.dart';
import 'package:style_me/core/views/input/app_text_field.dart';
import 'package:style_me/features/settings/data/models/report_category.dart';
import 'package:style_me/features/settings/presentation/state/view_models/settings_view_model.dart';

class SettingsReportBottomSheet extends ConsumerStatefulWidget {
  final Function(String) onSubmit;

  const SettingsReportBottomSheet({super.key, required this.onSubmit});

  @override
  ConsumerState<SettingsReportBottomSheet> createState() =>
      _SettingsReportBottomSheetState();
}

class _SettingsReportBottomSheetState
    extends ConsumerState<SettingsReportBottomSheet> {
  String reportText = "";
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        spacing: 12,
        children: [
          Text(
            localizations.whatsWrong,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          AppTextField(
            text: reportText,
            labelText: localizations.describeProblem,
            height: null,
            minLines: 8,
            maxLines: 8,
            onTextChanged: (text) {
              setState(() {
                reportText = text;
              });
            },
            errorText: errorMessage,
            onLostFocus: () => setState(() {
              errorMessage =
                  reportText.isEmpty ? localizations.textFieldEmpty : null;
            }),
          ),
          AppDropdownButton(
            items: ReportCategory.values,
            selectedItem: ref.watch(settingsViewModelProvider).selectedCategory,
            itemBuilder: (category) => Text(category.text),
            onItemSelect: (category) {
              ref
                  .read(settingsViewModelProvider.notifier)
                  .selectIssueReportCategory(category);
            },
          ),
          AppButton(
            text: localizations.send,
            onClick: reportText.isNotEmpty
                ? () {
                    widget.onSubmit(reportText);
                    context.pop();
                  }
                : null,
            enabled: reportText.isNotEmpty,
          )
        ],
      ),
    );
  }
}
