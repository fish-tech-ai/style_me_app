import 'package:flutter/material.dart';

class AppOutlinedButton extends StatelessWidget {
  final String text;
  final Function()? onClick;
  final ButtonStyle? style;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final double? spacing;

  const AppOutlinedButton(
      {super.key,
      required this.text,
      required this.onClick,
      this.style,
      this.leadingIcon,
      this.trailingIcon,
      this.spacing});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
          onPressed: onClick,
          style: style,
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
