import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/extensions/widget_ext.dart';
import 'package:style_me/core/utils/constants.dart';

class AppTextField extends StatefulWidget {
  final String text;
  final String labelText;
  final Function(String text) onTextChanged;
  final Function()? onTap;
  final Function()? onLostFocus;
  final Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final bool asPasswordField;
  final TextInputType? keyboardType;
  final bool isObscured;
  final Function()? onPasswordVisibilityTap;
  final String? errorText;

  const AppTextField({
    super.key,
    required this.text,
    required this.labelText,
    required this.onTextChanged,
    this.validator,
    this.enabled = true,
    this.onTap,
    this.errorText,
    this.onLostFocus,
    this.asPasswordField = false,
    this.onPasswordVisibilityTap,
    this.isObscured = true,
    this.keyboardType,
    this.onSubmitted,
    this.textInputAction,
    this.focusNode,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final TextEditingController controller;
  FocusNode localFocusNode = FocusNode();
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = widget.focusNode ?? localFocusNode;
    focusNode.addListener(handleFocusChange);
    controller = TextEditingController(text: widget.text);
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      focusNode.removeListener(handleFocusChange);
      focusNode = widget.focusNode ?? localFocusNode;
      focusNode.addListener(handleFocusChange);
    }
    if (widget.text != oldWidget.text && widget.text.isEmpty) {
      controller.clear();
    }
  }

  @override
  void dispose() {
    focusNode.removeListener(handleFocusChange);
    localFocusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  void handleFocusChange() {
    if (!focusNode.hasFocus) {
      widget.onLostFocus?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderSideColor = widget.errorText != null
        ? context.colorScheme.error
        : context.colorScheme.primary;

    return SizedBox(
      height: 76,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            obscureText: widget.isObscured,
            controller: controller,
            enabled: widget.enabled,
            validator: widget.validator,
            onChanged: widget.onTextChanged,
            onTap: widget.onTap,
            focusNode: focusNode,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            onFieldSubmitted: widget.onSubmitted,
            decoration: InputDecoration(
              errorStyle: TextStyle(height: 0),
              errorText: null,
              enabledBorder: OutlineInputBorder(
                borderRadius: GlobalUiConst.borderRadiusNormal,
                borderSide: BorderSide(color: borderSideColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: GlobalUiConst.borderRadiusNormal,
                borderSide: BorderSide(color: borderSideColor, width: 2),
              ),
              labelText: widget.labelText,
              floatingLabelStyle: TextStyle(color: borderSideColor),
              suffixIcon: widget.asPasswordField
                  ? _buildPasswordIcon(widget.errorText)
                  : null,
            ),
          ),
          Text(
            widget.errorText ?? "",
            style: TextStyle(color: context.colorScheme.error, fontSize: 12),
          ).orEmpty(widget.errorText == null)
        ],
      ),
    );
  }

  Widget _buildPasswordIcon(String? errorText) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      height: 56,
      width: 56,
      decoration: BoxDecoration(
        color: widget.isObscured
            ? errorText != null
                ? context.colorScheme.error
                : context.colorScheme.primary
            : Colors.transparent,
        borderRadius: BorderRadius.all(
          Radius.circular(GlobalUiConst.radiusNormal),
        ),
        border: Border.all(
          width: focusNode.hasFocus ? 2 : 1,
          color: errorText != null
              ? context.colorScheme.error
              : context.colorScheme.primary,
        ),
      ),
      child: IconButton(
        icon: Icon(
          widget.isObscured ? Icons.visibility : Icons.visibility_off,
          color: widget.isObscured
              ? context.colorScheme.onPrimary
              : errorText != null
                  ? context.colorScheme.error
                  : context.colorScheme.primary,
        ),
        onPressed: widget.onPasswordVisibilityTap,
        style: ButtonStyle(
          splashFactory: NoSplash.splashFactory, // Disable splash animation
        ),
      ),
    );
  }
}
