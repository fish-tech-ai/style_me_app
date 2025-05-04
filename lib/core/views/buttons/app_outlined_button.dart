import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/extensions/widget_ext.dart';
import 'package:style_me/core/views/default_loading_page.dart';

class AppOutlinedButton extends StatelessWidget {
  final String text;
  final Function()? onClick;
  final ButtonStyle? style;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final double? spacing;
  final double? height;
  final double? width;
  final Color? loadingIndicatorColor;
  final bool isLoading;
  final EdgeInsets padding;

  const AppOutlinedButton({
    super.key,
    required this.text,
    required this.onClick,
    this.style,
    this.leadingIcon,
    this.trailingIcon,
    this.spacing,
    this.height = 48,
    this.width,
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
    this.isLoading = false,
    this.loadingIndicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = OutlinedButton.styleFrom(padding: padding);
    return SizedBox(
      height: height,
      width: width,
      child: OutlinedButton(
          onPressed: onClick,
          style: style?.merge(defaultStyle) ?? defaultStyle,
          child: Row(
            spacing: spacing ?? 0,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              leadingIcon ?? SizedBox(),
              Text(text),
              trailingIcon ?? SizedBox(),
            ],
          ).or(
              DefaultLoading(
                color: loadingIndicatorColor ?? context.colorScheme.primary,
                size: Size.square(24),
              ),
              isLoading)),
    );
  }
}
