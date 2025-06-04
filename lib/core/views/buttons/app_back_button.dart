import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/utils/constants.dart';
import 'package:style_me/core/views/buttons/app_icon_button.dart';

class AppBackButton extends StatelessWidget {
  final Function()? onTap;
  final BoxBorder? border;
  final Color? backgroundColor;

  const AppBackButton({super.key, this.onTap, this.border, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return AppIconButton(
      backgroundColor: backgroundColor ?? context.colorScheme.primaryContainer,
      border: border,
      padding: EdgeInsets.all(GlobalUiConst.paddingNormal),
      disableVisualFeedback: true,
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
