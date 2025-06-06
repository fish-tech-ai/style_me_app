import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:style_me/core/extensions/context_ext.dart';

class EmptyPage extends StatelessWidget {
  final String title;
  final String subTitle;

  const EmptyPage({super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 42),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/no_clothes.svg",
            colorFilter: ColorFilter.mode(
                context.colorScheme.onSurface, BlendMode.srcIn),
          ),
          SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 6),
          Text(
            subTitle,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
