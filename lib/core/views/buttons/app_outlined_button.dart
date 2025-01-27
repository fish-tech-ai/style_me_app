import 'package:flutter/material.dart';

class AppOutlinedButton extends StatelessWidget {
  final String text;
  final Function()? onClick;
  final ButtonStyle? style;

  const AppOutlinedButton(
      {super.key, required this.text, required this.onClick, this.style});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
          onPressed: onClick,
          style: style,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(text)],
          )),
    );
  }
}
