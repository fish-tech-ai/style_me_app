import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/utils/constants.dart';

class AppBackButton extends StatelessWidget {
  final Function()? onTap;

  const AppBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      foregroundDecoration: BoxDecoration(
        borderRadius: GlobalUiConst.borderRadiusNormal,
        color: context.colorScheme.primaryContainer,
      ),
      child: IconButton(
        onPressed: () {
          onTap != null ? onTap!() : context.pop();
        },
        icon: Icon(Icons.keyboard_backspace_rounded),
      ),
    );
  }
}
