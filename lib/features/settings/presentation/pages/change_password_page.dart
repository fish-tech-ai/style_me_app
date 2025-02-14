import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/views/app_top_bar.dart';
import 'package:style_me/core/views/buttons/app_button.dart';
import 'package:style_me/core/views/input/app_text_field.dart';
import 'package:style_me/core/views/ui_models/app_button_icon.dart';
import 'package:style_me/core/views/ui_models/icon_position.dart';
import 'package:style_me/features/auth/presentation/ui_models/text_field_state.dart';
import 'package:style_me/features/settings/presentation/state/change_password_state_holder.dart';
import 'package:style_me/features/settings/presentation/state/change_password_view_model.dart';
import 'package:style_me/features/settings/presentation/ui_models/change_password_args.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  final ChangePasswordPageArgs changePasswordArgs;

  const ChangePasswordPage({super.key, required this.changePasswordArgs});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  late final ChangePasswordViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ref.read(changePasswordViewModelProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.changePasswordArgs.isResettingPass) {
        ref
            .read(appGlobalViewModelProvider.notifier)
            .setBottomNavBarVisibility(false);
      }
      viewModel.initFormValidators(
          context.localizations, widget.changePasswordArgs.isResettingPass);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ChangePasswordStateHolder state =
        ref.watch(changePasswordViewModelProvider);
    return SafeArea(
      child: Column(
        children: [
          AppTopBar(
            title: widget.changePasswordArgs.isResettingPass
                ? context.localizations.resetPasswordTitle
                : context.localizations.changePasswordTitle,
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              spacing: 6,
              children: [
                if (!widget.changePasswordArgs.isResettingPass)
                  _buildTextField(
                      textFieldState: state.oldPassword,
                      labelText: context.localizations.oldPassword,
                      onTextChanged: (text) {
                        viewModel.updateTextInput(oldPassword: text);
                      },
                      onLostFocus: (textFieldState) {
                        viewModel.updateErrorMessage(
                            oldPasswordError:
                                textFieldState.validate!(textFieldState.text));
                      },
                      onPasswordVisibilityTap: () {
                        viewModel.togglePasswordVisibility(
                            oldPassword: !state.oldPassword.isObscured);
                      }),
                _buildTextField(
                    textFieldState: state.newPassword,
                    labelText: context.localizations.newPassword,
                    onTextChanged: (text) {
                      viewModel.updateTextInput(newPassword: text);
                    },
                    onLostFocus: (textFieldState) {
                      viewModel.updateErrorMessage(
                          newPasswordError:
                              textFieldState.validate!(textFieldState.text));
                    },
                    onPasswordVisibilityTap: () {
                      viewModel.togglePasswordVisibility(
                          newPassword: !state.newPassword.isObscured);
                    }),
                _buildTextField(
                    textFieldState: state.verifyPassword,
                    labelText: context.localizations.verifyNewPassword,
                    onTextChanged: (text) {
                      viewModel.updateTextInput(verifyPassword: text);
                    },
                    onLostFocus: (textFieldState) {
                      viewModel.updateErrorMessage(
                          verifyPasswordError:
                              textFieldState.validate!(textFieldState.text));
                    },
                    onPasswordVisibilityTap: () {
                      viewModel.togglePasswordVisibility(
                          verifyPassword: !state.verifyPassword.isObscured);
                    }),
                AppButton(
                  text: context.localizations.changePasswordTitle,
                  icon: AppButtonIcon(Icons.keyboard_arrow_right_rounded,
                      IconPosition.trailing),
                  enabled: state.isAllValidated,
                  isLoading: state.isLoading,
                  onClick: () {
                    onChangePasswordButtonClicked();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void onChangePasswordButtonClicked() {
    viewModel.changePassword(widget.changePasswordArgs, context.localizations,
        () {
      ref
          .read(appGlobalViewModelProvider.notifier)
          .showSuccessInfo(context.localizations.passwordHasBeenChanged);
      context.pop();
    });
  }

  Widget _buildTextField({
    required TextFieldState textFieldState,
    required String labelText,
    required Function(String) onTextChanged,
    required Function(TextFieldState) onLostFocus,
    required Function() onPasswordVisibilityTap,
  }) {
    return AppTextField(
      text: textFieldState.text,
      labelText: labelText,
      onTextChanged: onTextChanged,
      asPasswordField: true,
      errorText: textFieldState.errorText,
      isObscured: textFieldState.isObscured,
      onLostFocus: () => onLostFocus(textFieldState),
      onPasswordVisibilityTap: onPasswordVisibilityTap,
      focusNode: textFieldState.focusNode,
      keyboardType: TextInputType.visiblePassword,
      textInputAction:
          textFieldState.isLast ? TextInputAction.done : TextInputAction.next,
      onSubmitted: (_) {
        if (textFieldState.isLast) {
          textFieldState.focusNode?.unfocus();
          onChangePasswordButtonClicked();
        } else {
          textFieldState.focusNode?.nextFocus();
        }
      },
    );
  }
}
