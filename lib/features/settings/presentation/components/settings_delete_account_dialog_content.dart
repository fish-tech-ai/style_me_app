import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/views/buttons/app_button.dart';
import 'package:style_me/core/views/buttons/app_outlined_button.dart';
import 'package:style_me/core/views/input/app_text_field.dart';
import 'package:style_me/features/settings/presentation/state/delete_dialog_state.dart';
import 'package:style_me/features/settings/presentation/state/view_models/settings_view_model.dart';

class SettingsDeleteAccountDialogContent extends ConsumerWidget {
  final Function() onDeleteClicked;

  const SettingsDeleteAccountDialogContent(
      {super.key, required this.onDeleteClicked});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DeleteDialogState state = ref.watch(
      settingsViewModelProvider.select(
        (settingsState) => settingsState.deleteDialogState,
      ),
    );
    final isValidated = state.errorMessage == null;
    return Column(
      spacing: 12,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          localizations.areYouSure,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        Text(localizations.deleteAccountWarning),
        AppTextField(
          text: state.password,
          asPasswordField: true,
          errorText: state.errorMessage,
          isObscured: !state.isPasswordVisible,
          onPasswordVisibilityTap: () => ref
              .read(settingsViewModelProvider.notifier)
              .toggleDeleteDialogPassVisibility(),
          labelText: localizations.password,
          onTextChanged: (text) => {
            ref
                .read(settingsViewModelProvider.notifier)
                .changeDeleteDialogPassText(text)
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppOutlinedButton(
              text: localizations.cancel,
              height: 46,
              width: 128,
              onClick: () => context.pop(),
            ),
            AppButton(
              text: localizations.deleteAccount,
              backgroundColor: context.colorScheme.error,
              height: 46,
              width: 128,
              onClick: isValidated
                  ? () {
                      onDeleteClicked();
                    }
                  : null,
              enabled: isValidated,
            ),
          ],
        )
      ],
    );
  }
}
