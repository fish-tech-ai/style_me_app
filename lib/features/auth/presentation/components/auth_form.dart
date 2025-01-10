import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/extensions/widget_ext.dart';
import 'package:style_me/core/views/animated_content.dart';
import 'package:style_me/core/views/buttons/app_button.dart';
import 'package:style_me/core/views/input/app_text_field.dart';
import 'package:style_me/core/views/ui_models/app_button_icon.dart';
import 'package:style_me/core/views/ui_models/icon_position.dart';
import 'package:style_me/features/auth/presentation/state/auth_state_holder.dart';
import 'package:style_me/features/auth/presentation/state/auth_view_model.dart';
import 'package:style_me/features/auth/presentation/ui_models/auth_page_mode_enum.dart';
import 'package:style_me/features/auth/presentation/ui_models/text_field_state.dart';

class AuthForm extends StatelessWidget {
  final AuthViewModel viewModel;
  final AuthStateHolder state;

  const AuthForm({super.key, required this.viewModel, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 2,
      children: [
        buildFormTextField(
            context: context,
            label: context.localizations.firstName,
            textFieldInfo: state.firstName,
            keyboardType: TextInputType.name,
            onTextChanged: (String text) {
              viewModel.updateTextInput(firstName: text);
            },
            onLostFocus: (textFieldState) {
              viewModel.updateErrorMessage(
                  firstNameError:
                      textFieldState.validate!(textFieldState.text));
            }),
        buildFormTextField(
            context: context,
            label: context.localizations.surname,
            textFieldInfo: state.surname,
            keyboardType: TextInputType.name,
            onTextChanged: (String text) {
              viewModel.updateTextInput(surname: text);
            },
            onLostFocus: (textFieldState) {
              viewModel.updateErrorMessage(
                  surnameError: textFieldState.validate!(textFieldState.text));
            }),
        buildFormTextField(
            context: context,
            label: context.localizations.email,
            textFieldInfo: state.email,
            keyboardType: TextInputType.emailAddress,
            onTextChanged: (String text) {
              viewModel.updateTextInput(email: text);
            },
            onLostFocus: (textFieldState) {
              viewModel.updateErrorMessage(
                  emailError: textFieldState.validate!(textFieldState.text));
            }),
        buildFormTextField(
          context: context,
          label: context.localizations.password,
          textFieldInfo: state.password,
          keyboardType: TextInputType.visiblePassword,
          asPasswordField: true,
          isPasswordVisible: state.isPasswordVisible,
          onPasswordVisibilityTap: () {
            viewModel.togglePasswordVisibility();
          },
          onTextChanged: (text) {
            viewModel.updateTextInput(password: text);
          },
          onLostFocus: (textFieldState) {
            viewModel.updateErrorMessage(
                passwordError: textFieldState.validate!(textFieldState.text));
          },
        ),
        buildFormTextField(
          context: context,
          label: context.localizations.verifyPassword,
          textFieldInfo: state.passwordVerify,
          keyboardType: TextInputType.visiblePassword,
          asPasswordField: true,
          isPasswordVisible: state.isPasswordVerifyVisible,
          onPasswordVisibilityTap: () {
            viewModel.togglePasswordVerifyVisibility();
          },
          onTextChanged: (text) {
            viewModel.updateTextInput(passwordVerify: text);
          },
          onLostFocus: (textFieldState) {
            viewModel.updateErrorMessage(
                passwordVerifyError:
                    textFieldState.validate!(textFieldState.text));
          },
        ),
        AnimatedVisibility(
          isVisible: state.mode == AuthPageModeEnum.emailAndPassword,
          reversed: true,
          child: InkWell(
            onTap: () {},
            child: Text(
              context.localizations.forgotPassword,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ),
        SizedBox(height: 16)
            .orEmpty(state.mode != AuthPageModeEnum.emailAndPassword),
        AppButton(
          text: context.localizations.continueText,
          enabled: state.isAllValidated,
          icon: AppButtonIcon(
              Icons.keyboard_arrow_right_rounded, IconPosition.trailing),
          onClick: () => continueIfValidated(),
        ),
      ],
    );
  }

  void continueIfValidated() {
    state.isAllValidated
        ? viewModel.onContinueButtonClicked()
        : viewModel.validateAndShowAll();
  }

  Widget buildFormTextField({
    required BuildContext context,
    required String label,
    required TextFieldState textFieldInfo,
    required Function(String text) onTextChanged,
    required Function(TextFieldState) onLostFocus,
    TextInputType? keyboardType,
    bool asPasswordField = false,
    Function()? onPasswordVisibilityTap,
    bool isPasswordVisible = true,
  }) {
    return AnimatedVisibility(
      isVisible: textFieldInfo.isVisible,
      padding: EdgeInsets.only(top: 4),
      child: AppTextField(
        text: textFieldInfo.text,
        labelText: label,
        keyboardType: keyboardType,
        errorText: textFieldInfo.errorText,
        focusNode: textFieldInfo.focusNode,
        textInputAction:
            textFieldInfo.isLast ? TextInputAction.done : TextInputAction.next,
        onSubmitted: textFieldInfo.isLast
            ? (text) {
                continueIfValidated();
                textFieldInfo.focusNode?.unfocus();
                return text;
              }
            : (text) {
                FocusScope.of(context)
                    .requestFocus(state.focusNodes[textFieldInfo.position + 1]);
                return text;
              },
        onTextChanged: onTextChanged,
        asPasswordField: asPasswordField,
        isObscured: !isPasswordVisible,
        onPasswordVisibilityTap: onPasswordVisibilityTap,
        onLostFocus: () => onLostFocus(textFieldInfo),
      ),
    );
  }
}
