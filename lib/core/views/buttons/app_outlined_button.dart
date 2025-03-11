import 'package:flutter/material.dart';

class AppOutlinedButton extends StatelessWidget {
  final String text;
  final Function()? onClick;
  final ButtonStyle? style;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final double? spacing;
  final double? height;
  final double? width;
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
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
    this.width,
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
          )),
    );
  }
}
