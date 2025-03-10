import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/views/buttons/app_icon_button.dart';

class AppBackButton extends StatelessWidget {
  final Function()? onTap;
  final BoxBorder? border;

  const AppBackButton({super.key, this.onTap, this.border});

  @override
  Widget build(BuildContext context) {
    return AppIconButton(
      backgroundColor: context.colorScheme.primaryContainer,
      border: border,
      onClick: () {
        onTap != null ? onTap!() : context.pop();
      },
      icon: Icon(
        Icons.keyboard_backspace_rounded,
        size: 24,
        color: context.colorScheme.primary,
      ),
    );
  }
}
