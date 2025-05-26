import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/utils/constants.dart';

class HomeHeaderBanner extends StatelessWidget {
  final String userName;

  const HomeHeaderBanner({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: GlobalUiConst.borderRadiusExtraLarge
          .copyWith(topLeft: Radius.zero, topRight: Radius.zero),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/home_header_image.png"),
                fit: BoxFit.cover),
          ),
          child: InkWell(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: context.colorScheme.primaryContainer,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 36),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            localizations.homeHeaderGreetings(userName),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: context.colorScheme.onPrimary,
                            ),
                          ),
                          Text(
                            localizations.homeHeaderSubTitle,
                            style: TextStyle(
                              color: context.colorScheme.onPrimary,
                            ),
                          ),
                          Text(
                            localizations.homeHeaderSeeHowItWorks,
                            style: TextStyle(
                              color: context.colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.keyboard_arrow_right_rounded,
                        size: 36,
                        color: context.colorScheme.onPrimary,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
