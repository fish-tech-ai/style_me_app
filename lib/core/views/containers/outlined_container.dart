import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/utils/constants.dart';

class OutlinedContainer extends StatelessWidget {
  final Widget child;

  const OutlinedContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 600,
      decoration: BoxDecoration(
        color: context.customColors.backgroundA85,
        border: Border.all(color: context.colorScheme.primary),
        borderRadius: GlobalUiConst.borderRadiusExtraLarge,
      ),
      padding: EdgeInsets.symmetric(
          vertical: 16, horizontal: GlobalUiConst.paddingNormal),
      margin: EdgeInsets.symmetric(horizontal: GlobalUiConst.paddingNormal),
      child: child,
    );
  }
}
