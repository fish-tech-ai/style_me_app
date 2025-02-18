import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/views/buttons/app_button.dart';
import 'package:style_me/core/views/input/app_text_field.dart';

class SettingsReportBottomSheet extends StatefulWidget {
  final Function(String) onSubmit;

  const SettingsReportBottomSheet({super.key, required this.onSubmit});

  @override
  State<SettingsReportBottomSheet> createState() =>
      _SettingsReportBottomSheetState();
}

class _SettingsReportBottomSheetState extends State<SettingsReportBottomSheet> {
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
          AppButton(
            text: localizations.send,
            onClick: reportText.isNotEmpty
                ? () {
                    widget.onSubmit(reportText);
                    context.pop(); //TODO add loading before context.pop() when backend will be ready
                  }
                : null,
            enabled: reportText.isNotEmpty,
          )
        ],
      ),
    );
  }
}
