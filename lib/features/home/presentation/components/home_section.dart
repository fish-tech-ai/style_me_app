import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/utils/constants.dart';

class HomeSection extends StatelessWidget {
  final String title;
  final Function() onSeeMoreClicked;
  final Widget child;

  const HomeSection({
    super.key,
    required this.title,
    required this.onSeeMoreClicked,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12, right: 12, top: 24, bottom: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              buildSeeMoreButton(context)
            ],
          ),
        ),
        child
      ],
    );
  }

  Widget buildSeeMoreButton(BuildContext context) {
    return InkWell(
      onTap: onSeeMoreClicked,
      borderRadius: GlobalUiConst.borderRadiusSmall,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        child: Row(
          spacing: 3,
          children: [
            Text(localizations.seeMore),
            Icon(
              Icons.keyboard_arrow_right_rounded,
              color: context.colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }
}
